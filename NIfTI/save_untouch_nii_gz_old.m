%  Wrapper to save_untouch_nii, to write nii.gz files
%  - Guray Erus, Jan 26 2011
%
function save_untouch_nii_gz(nii, filename)

	if ~exist('nii','var') | isempty(nii) | ~isfield(nii,'hdr') | ...
		~isfield(nii,'img') | ~exist('filename','var') | isempty(filename)
	
		error('Usage: save_untouch_nii(nii, filename)');
	end

	% Create nii file
	[PATHSTR,NAME,EXT,VERSN] = fileparts(filename);
	if strcmp(EXT, 'gz') == 0
		if isempty(PATHSTR)
			newFileName = [NAME];
		else
			newFileName = [PATHSTR '/' NAME];
		end
		save_untouch_nii(nii, newFileName);

		% Zip nii file	
		try
			s = system(['gzip ' newFileName]);
		catch
			disp('WARNING: Could not zip nii file ...');
		end
	else
		save_untouch_nii(nii, filename);
	end
