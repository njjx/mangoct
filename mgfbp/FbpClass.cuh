#pragma once
#include <string>
#include <vector>

namespace mango
{
	struct Config
	{
		/*********************************************************
		* input and output directory and files
		*********************************************************/
		std::string		inputDir;
		std::string		outputDir;
		std::vector<std::string>	inputFiles;
		std::vector<std::string>	outputFiles;

		bool		saveFilterSinogram;

		/*********************************************************
		* sinogram and slice parameters
		*********************************************************/
		unsigned	sgmWidth;				// sinogram width (number of detector elements)
		unsigned	sgmHeight;				// sinogram height (number of frames)
		unsigned	views;					// number of views for reconstruction
		unsigned	sliceCount;				// number of slice in each sinogram file
		float		sliceThickness = 1;		// slice thickness of each slice for cone beam recon [mm]
		float		sliceOffcenter = 0;		//slice offcenter distance for cone beam recon [mm]

		float		totalScanAngle;			// total scan angle for short scan
		bool		nonuniformScanAngle;	// whether the scan angles are nonuniform
		bool		shortScan;				// whether the scan is a short scan
		std::string		scanAngleFile;		// name of the jsonc file to save the scan angle information

		float		detEltSize;				// physical size of detector element [mm]
		float		detOffCenter;			// the position (coordinate) of center of detector

		float		sid;					// source to isocenter distance [mm]
		float		sdd;					// source to detector distance [mm]

		/*********************************************************
		* reconstruction parameters
		*********************************************************/
		bool		doBeamHardeningCorr;	// need beam hardening correction or not
		bool		coneBeam = false;		// whether the recon is a bone beam or fan beam
		float		beamHardening[10] = { 0 };		// beam hardening parameters

		unsigned	imgDim;					// number of rows/cols of reconstructed images
		float		pixelSize;				// image pixel size [mm]

		float		imgRot;					// rotate the image [degree]
		
		float		xCenter;				// the center of reconstructed image [x mm, y mm]
		float		yCenter;				// the center of reconstructed image [x mm, y mm]

		float		zCenter = 0;			// the center of reconstructed image in the Z direction [mm]
		float		imgSliceThickness; 		// image slice thickness [mm]
		unsigned	imgSliceCount;			// image slice count


		std::string	kernelName;				// reconstruction kernel name
		std::vector<float>	kernelParam;	// reconstruction kernel parameters
	};


	class FbpClass
	{
	public:
		static Config config;

	private:
		// array of detector element coordinate
		static float* u;
		// array of detector element in z direction
		static float* v;
		// array of each view angle [radius]
		static float* beta;
		// array of reconstruction kernel
		static float* reconKernel;


	private:
		float* sinogram = nullptr;
		float* sinogram_filter = nullptr;
		float* image = nullptr;

	public:
		FbpClass();
		~FbpClass();


		// Read config file
		void ReadConfigFile(const char* filename);

		// Initialize parameters
		void InitParam();

		// Read sinogram file
		void ReadSinogramFile(const char* filename);

		// Save filtered sinogram data to file
		void SaveFilteredSinogram(const char* filename);

		// Perform beam hardening correction
		void CorrectBeamHardening();

		// Save image to file
		void SaveImage(const char* filename);

		// Filter the current sinogram data
		void FilterSinogram();

		// Backproject the image using pixel-driven method
		void BackprojectPixelDriven();

	};


}


