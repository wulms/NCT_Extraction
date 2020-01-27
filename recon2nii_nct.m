function recon2nii_nct(value,instr)
% recon2nii(value)
% 
% Wandelt die Koordinaten aus einer (REX)Datei mit entsprechenden
% Grauwerten in eine Nifti-Datei um.
% 
% Wähle die REX.mat Datei aus, die die Koordinaten enthält.
% Es erfolgt eine Generierung einer *.nii-Datei, mit den Grauwerten
% und Positionen der Voxel aus der REX.mat-Datei. Die zugehoerige Basis-
% Header-Datei (Maske,...) wird aus Feld mit entspr. Pfad aus der REX-Datei
% geladen.
% Die neue Datei hat die Bezeichnung 'value_recon.nii'.
% 
% Nutzung:
% 	>> recon2nii(value)
% 		--> Waehle gewünschte Daten aus, die rückprojiziert werden soll.
%       wo 'value': Grauwerte die an 'coord'-Position geschrieben werden
%                   wo [nx1 double]]
%	
%   Falls REX.mat in aktuellen Pfad nicht automatisch geladen werden soll,
%   kommentiere aus:
%       % automatisch die REX.mat... --> load('REX.mat');
%   fuer manuelle Auswahl:
%       % ueber manuelle Auswahl der REX... --> file = uigetfile(...
% 	
%   Falls Basis-hdr-Datei (Maske,...) anders, sollte aber gleiche Ausmasse
%   haben, oder nicht mehr im Ursprungspfad, dann auskommentiere in:
%		% Lade Header ...	--> newmat_hdr = read_nii_hdr(params.rois);
%	fuer manuelle Wahl:
%		% Lade Header der gewuenschten Basis-Nifti-Datei:
%           --> file = uigetfile(...
%
%
% --------------------
% last edit 09.07.2013
% edit 20130214 bg: - wenn params.rois eine *.img ist, waehle die entspr. 
%                       *.hdr aus. Bei *.nii klappt es.
%                   - fuege kurfristig den Pfad zur params.rois ein/aus
%                   - erzeuge nii-Datei mit Name der uebergebenen Variablen
% edit 20130221 bg: - mögliches automatisches einlesen der REX.mat
%					- Falls in params.rois eine *.img-Datei verwendet wurde,
%						nutze entspr. *.hdr-Datei
%                       -> schreibe in geladenen Header andere Parameter
% edit 20130709 bg: - lade REX.mat automatisch oder falls schon geladen,
%                       uebernehme 'params' aus Basis-workspace
%                   - setze .datatype/.bitpix -> 16/32, sodass Kommazahlen
%                       und Zahlen groesser 32767 (int16) erfasst werden.
% edit 20140805 bg:	- hdr-Informtation wird aus REX-Datei ausgelesen, statt Pfad zu masken-hdr
%					- schleife zu Masken-hdr wird nur abgefragt, falls
%					REX.mat KEINE hdr-Info enthällt
% 
% edit 20140814 sh: -   Änderung der REX.mat Abfrage: Jetzt wird ZUERST der "Caller" 
%                       Workspace nach dem struct 'params' durchsucht (war "base"), damit er ggf. verwendet
%                       werden kann. Ansonsten wird automatisch nach REX.mat im current directory
%                       gesucht
%                   -   Bei Eingabe eines Strings als Input wird die
%                       Funktion abgebrochen um Fehler zu vermeiden
%---------------------
%
% (c) 2012 Benjamin Glaubitz 
% Universitäts- und Poliklinik Bergmannsheil, Bochum
% Falls Käfer auftauchen:  benjamin.glaubitz@bergmannsheil.de
%

%%
% Error handling, falls statt eines Variabelnamens ein String als Input
% übergeben wird
if ischar(value)
    error('***  You must not enter a string as input when using "recon2nii"');
end;


% Lade REX.mat Datei
% % automatisch die REX.mat Datei nehmen, die im aktuellen Ordner ist, oder
% falls schon in einem script vorher geladen nehme die Variable 'params'
% aus dem Basis-workspace.
params = evalin('caller','params');

if ~isstruct(params)
    load('REX.mat');
end;
% % ueber manuelle Anwahl der REX.mat Datei
% file = uigetfile('*.mat','Lade REX-Datei');
% disp(['FDI: Lade gewuenschte *.mat Datei = ' file]);
% load(file);
% clear file;

%%
% Lade Header der Basis-Nifti-Datei - aus params.rois, wo Pfad integriert
% Falls in params.rois eine *.img-Datei verwendet wurde, nutze entspr.
% *.hdr-Datei
[pathstr, name, ext] = fileparts(params.rois);
if ext=='.img'
    roi_path = strcat(pathstr,'\',name,'.hdr');
else
    roi_path = params.rois;
end;

addpath(fileparts(params.rois));
newmat_hdr = read_nii_hdr(roi_path);
rmpath(fileparts(params.rois));
% % Lade Header der gewünschten Basis-Nifti-Datei
% file = uigetfile('*.hdr;*.nii','Lade Header der Basis-nii-Datei');
% disp(['FDI: Nutze Nifti-Header der Datei = ' file]);
% addpath(fileparts(params.rois));
% newmat_hdr = read_nii_hdr(file);
% rmpath(fileparts(params.rois));

%%
% Baue entsprechende Matrix mit Dimensionen der Basis-Nifti-Datei
newmat = zeros(newmat_hdr.dim(2),newmat_hdr.dim(3),newmat_hdr.dim(4),newmat_hdr.dim(5));

%%
% Lade und Schreibe params-voxel an die Position in Matrix
% mit beliebigen Grauwerten, entsprechend des Parameters x, s.u.
vxl=params.ROIinfo.voxels{1,1}{1,1};

%%
% Lade Grauwerte aus REX-Datei bzw. aus params.ROIinfo.basis und bestimme
% Länge
%x = params.ROIinfo.basis{1,1}{1,1};
%lx = length(x);
% edit_BG_20130212
x = value;
lx = length(x);

%%
% scl_slope   Data scaling: If the scl.slope field is nonzero,
%                 then each voxel value in the dataset should
%                 be scaled as y = scl.slope*x + scl.inter,
%                 where x = voxel value stored and y = "true"
%                 voxel value
% So wähle einen Korrekturfaktor, sodass weniger Rundungsfehler
% auftauschen:
%newmat_hdr.scl_slope=1/10000; kein 1/10000, da Datentyp int16 Daten ueber
% 32767 nicht verarbeiten kann. 
newmat_hdr.scl_slope=1;
% Aendere z.B.  .datatype = 4 -> 16      (signed short = int   ->   float)
%               .bitpix = 16  -> 32
% .datatype + .bitpix sind voneinander abhaengig.
newmat_hdr.datatype = 16;
newmat_hdr.bitpix = 32;

% Falls Basis-Header hdr/img-Format {newmat_hdr.magic : ni1}
% (bei *.nii ist newmat_hdr.magic : n+1)
%_% /* DATA STORAGE: ------------ If the magic field is "n+1", then the
%_% voxel data is stored in the same file as the header. In this case, the
%_% voxel data starts at offset (int)vox_offset into the header file. Thus,
%_% vox_offset=352.0 means that the data starts immediately after the
%_% NIFTI-1 header. If vox_offset is greater than 352, the NIFTI-1 format
%_% does not say much about the contents of the dataset file between the
%_% end of the header and the start of the data.
%_%
%_% FILES: ----- If the magic field is "ni1", then the voxel data is stored
%_% in the associated ".img" file, starting at offset 0 (i.e., vox_offset
%_% is not used in this case, and should be set to 0.0).
if newmat_hdr.magic(2)== 'i';
    newmat_hdr.vox_offset = 352;
    newmat_hdr.magic(2) = '+';
    newmat_hdr.originator = [0;0;0;0;0];
end
%%
% Siehe Nifti-Dokumentation "sform_code > 0": 
% Wenn man auf Standardgitter projizieren will, dann gilt für die
% Raumkoordinaten (x,y,z) bzgl. der Matrixpositionen (i,j,k):
% x = srow_x(1)*i + srow_x(2)*j + srow_x(3)*k + srow_x(4)
% y = srow_y(1)*i + srow_y(2)*j + srow_y(3)*k + srow_y(4)
% z = srow_z(1)*i + srow_z(2)*j + srow_z(3)*k + srow_z(4)
% Dies auflösen nach i,j,k:
A = [newmat_hdr.srow_x(1) newmat_hdr.srow_x(2) newmat_hdr.srow_x(3) ;newmat_hdr.srow_y(1) newmat_hdr.srow_y(2) newmat_hdr.srow_y(3); newmat_hdr.srow_z(1) newmat_hdr.srow_z(2) newmat_hdr.srow_z(3)];
B = inv(A);

%%
% Schreibe Grauwerte an Koordinaten in der neuen Matrix:
for i=1:lx
newmat(B(1,1)*(vxl(i,1)-newmat_hdr.srow_x(4))+B(1,2)*(vxl(i,2)-newmat_hdr.srow_y(4))+B(1,3)*(vxl(i,3)-newmat_hdr.srow_z(4))+1,B(2,1)*(vxl(i,1)-newmat_hdr.srow_x(4))+B(2,2)*(vxl(i,2)-newmat_hdr.srow_y(4))+B(2,3)*(vxl(i,3)-newmat_hdr.srow_z(4))+1,B(3,1)*(vxl(i,1)-newmat_hdr.srow_x(4))+B(3,2)*(vxl(i,2)-newmat_hdr.srow_y(4))+B(3,3)*(vxl(i,3)-newmat_hdr.srow_z(4))+1)=x(i);
end

%%
% Schreibe, mit Scott Peltiers Niftiwriter, neue Matrix mit Header
% aus gewünschter Datei in neue Nii-Datei, wobei die Daten entsprechen der
% scl_slope^(-1) geändert werden, wobei die Datei in den gerade aktuellen
% Matlabpfad geschrieben wird:
    % Erzeuge Dateiname mit Bezeichnung der uebergebenen Variablen
    dateiname = instr;
    dateiname = strcat(dateiname,'_recon.nii');

%write_nii('recon.nii',10000*newmat,newmat_hdr,0)
%write_nii(dateiname,10000*newmat,newmat_hdr,0) % keine Multiplikation mit
% 10000, da auch kein scl_slope = 1/10000 ; da Datentyp int16 Zahlen ueber
% 32767 nicht verarbeiten kann.
write_nii(dateiname,newmat,newmat_hdr,0)

fprintf('\n Es wurde die Datei "%s" erzeugt.',dateiname)

clear;


end