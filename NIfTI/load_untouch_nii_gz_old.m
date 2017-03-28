%  Wrapper to load_untouch_nii, to read nii.gz files
%  - Guray Erus, Jan 26 2011
%
function nii = load_untouch_nii_gz(filename, img_idx, dim5_idx, dim6_idx, dim7_idx)

	if ~exist('filename','var')
		error('Usage: nii = load_untouch_nii_gz(filename, [img_idx], [dim5_idx], [dim6_idx], [dim7_idx])');
	end
	
	if ~exist('img_idx','var') | isempty(img_idx)
		img_idx = [];
	end
	
	if ~exist('dim5_idx','var') | isempty(dim5_idx)
		dim5_idx = [];
	end
	
	if ~exist('dim6_idx','var') | isempty(dim6_idx)
		dim6_idx = [];
	end
	
	if ~exist('dim7_idx','var') | isempty(dim7_idx)
		dim7_idx = [];
	end

	nii = [];
	[PATHSTR,NAME,EXT,VERSN] = fileparts(filename);

	if strcmp(EXT, 'gz') == 0
		[PATHSTR2,NAME2,EXT2,VERSN2] = fileparts(NAME);
		tmpFileName = tempname;
		tmpFileName = [tmpFileName EXT2];
		
		% Unzip .gz
		try
			s = system(['gzip -c -d ' filename ' > ' tmpFileName]);
		catch
			disp('ERROR: Could not unzip .gz file ...');
			return;
		end
		
		% Read nifti	
		nii = load_untouch_nii(tmpFileName, img_idx, dim5_idx, dim6_idx, dim7_idx);
	
		% Remove unzipped temp file	
		s = system(['rm ' tmpFileName]);
	else
		nii = load_untouch_nii(filename, img_idx, dim5_idx, dim6_idx, dim7_idx);
	end
