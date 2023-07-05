*-----------------------------------------------------------------
* FoxPro autotranslation of: \EZTwain\VC\Eztwain.h
* EZTwain 3.40.0.8, XDefs 1.39b1
*-----------------------------------------------------------------
* EZTWAIN.H - Easy interface to TWAIN library
* Copyright (C) 1999-2009 by Dosadi.
*
* This interface and the library which implements it, are the property of
* Dosadi and are protected by US and International copyright and trademark
* laws and treaties.  Dosadi strives to make this software both reliable,
* comprehensive, efficient, and affordable.  Do not use this software without
* obtaining a license for your use.
* 
* Sales, support and licensing information at: www.dosadi.com
*

DECLARE LONG TWAIN_Testing123 IN Eztwain3.dll ;
   STRING s, ;
   LONG n, ;
   LONG h, ;
   DOUBLE d, ;
   LONG u
* Displays a dialog box showing the parameter values received by the function.
* Pass in any valid values for the parameters - if they are faithfully
* displayed in the dialog box when you call this function, then parameter
* passing from your program to EZTwain is probably working correctly.
*
* Returns the value of the HDIB h parameter.

*--------- Top-Level Calls

DECLARE TWAIN_ResetAll IN Eztwain3.dll
* Resets EZTwain to default/just loaded state.
* (Except diagnostic logging, which is unaffected.)
* Any global settings are reset to initial values.
* Any open files are closed.
* Any open TWAIN device is closed.
* This function is used to place EZTwain in a 'known state'
* before starting a sequence of scanning calls.

DECLARE LONG TWAIN_Acquire IN Eztwain3.dll ;
   LONG hwndApp
* Acquires a single image, from the currently selected Data Source.
*
* The parameter is a Win32 Window Handle.  In most applications you
* can use 0 or NULL, but on Citrix and WTS, this must be a top-level window
* or a child of a top level window.
*
* The return value is a handle to global memory containing a DIB - 
* a Device-Independent Bitmap.  Numerous EZTWAIN DIB_xxx functions can
* be used to examine, modify, and save these DIB images.
* Warning: Remember to call DIB_Free on each DIB when you are done with it!
*
* Normally only one image is acquired per call: All Acquire functions shut
* down TWAIN before returning.  Use TWAIN_SetMultiTransfer to change this.
*
* By default, the default data source (DS) is opened, displays its dialog,
* and determines all the parameters of the acquisition and transfer.
* If you want to (try to) hide the DS dialog, see TWAIN_SetHideUI.
* To set acquisition parameters, you need to do something like this:
*     TWAIN_OpenDefaultSource() -or- TWAIN_OpenSource(sourceName)
*     TWAIN_Set*        - one or more capability-setting functions
*     hdib = TWAIN_Acquire(hwnd)
*     if (hdib) then ... process image, TWAIN_FreeNative(hdib); end

DECLARE LONG TWAIN_SelectImageSource IN Eztwain3.dll ;
   LONG hwnd
* Display the standard TWAIN "Select Source" dialog which
* allows the user to specify the system-wide default TWAIN device.
*
* Note this is a configuration function, it does not open or activate the device.
* See: TWAIN_GetDefaultSourceName and TWAIN_OpenDefaultSource.
*
* Note: If only one TWAIN device is installed on a system, TWAIN selects it
* automatically, so there is no need for the user to do Select Source.
* You should not require your users to do Select Source before Acquire.
*
* It returns after the user either OK's or CANCEL's the dialog.
* A return of TRUE(1) indicates OK, FALSE(0) indicates one of the following:
*   a) The user cancelled the dialog
*   b) The Source Manager found no data sources installed
*   c) There was a failure before the Select Source dialog could be posted
*

DECLARE LONG TWAIN_AcquireMemory IN Eztwain3.dll ;
   LONG hwnd
* Like TWAIN_Acquire, but always specifies a 'memory mode' transfer.

* Functions to do a memory transfer in individual blocks:
DECLARE LONG TWAIN_BeginAcquireMemory IN Eztwain3.dll ;
   LONG hwnd, ;
   LONG nRows
* Begin a memory transfer.
* Returns TRUE(1) if the transfer is ready to proceed (using
* TWAIN_AcquireMemoryBlock, below.)
* Returns FALSE(0) if the transfer could not be started for some reason.
*
* Loads TWAIN if necessary, opens the default source if no source is open.
* If it opens a source, it negotiates any 'pending' settings (resolution,
* pixel type, etc.) that were specified before the device was open.
* Enables the device if not already enabled.
* Waits for a 'transfer ready' message from the device.
* Tells the driver to begin transferring in blocks of nRows rows or less.
* If nRows is <= 0, lets the driver pick the optimal block size.

DECLARE LONG TWAIN_AcquireMemoryBlock IN Eztwain3.dll
* Acquire the next block of data in a memory transfer.
* If there is an error or there is no more data, returns NULL(0).
* Only valid after a successful call to TWAIN_BeginAcquireMemory (above.)
* Asks the device to deliver another block of pixels, and returns
* those pixels as a DIB represented by its handle.  This is the same
* image format returned by TWAIN_AcquireNative, TWAIN_AcquireMemory, etc.
* See the DIB_* functions for what can be done with the returned handle.

DECLARE LONG TWAIN_EndAcquireMemory IN Eztwain3.dll
* Clean up after a block-by-block memory transfer.
* Only valid after a successful call to TWAIN_BeginAcquireMemory (above.)
* Frees any temporary storage, and tells the device the transfer
* is over.  In Multi-transfer mode, the device will move to
* State 6 if more images are available, or State 5 if not.
* In single-transfer mode (the default) the device is automatically closed.


DECLARE LONG TWAIN_AcquireToFilename IN Eztwain3.dll ;
   LONG hwndApp, ;
   STRING sFileName
* Acquire an image and save it to a file.
* If the filename is NULL or an empty string, the user is prompted for
* the file name using a standard Save File dialog.
*
* The minimal use of EZTwain is to call this function with both arguments NULL (0).
*
* If the filename passed as a parameter or entered by the user contains a
* standard extension (.bmp, .jpg/.jpeg, .tif/.tiff, .png, .pdf, .gif, .dcx)
* then the file is saved in the implied format.
* Otherwise the file is saved in the current SaveFormat - see TWAIN_SetSaveFormat.

* See also TWAIN_AcquireFile below.
*
* Return values:
*   0  success.
*  -1  the Acquire failed.
*  -2  file open error (invalid path or name, or access denied)
*  -3  invalid DIB, or image incompatible with file format, or...
*  -4  writing failed, possibly output device is full.
* -10  user cancelled File Save dialog


DECLARE LONG TWAIN_AcquireMultipageFile IN Eztwain3.dll ;
   LONG hwndApp, ;
   STRING sFileName
* Acquire (scan) all available images to a multipage file.
* If the filename is NULL or points to the null string, the user is
* prompted for the filename.
* If the filename ends with ".tif", ".tiff", or
* ".mpt" the file is written in TIFF format.
* If the filename ends with ".pdf" the file is written in PDF format.
* Otherwise, the default multipage format is used, as set by SetMultipageFormat.
* If it has not been set, the default multipage format is TIFF.
*
* If scanning fails or is cancelled before the first writable page
* is received, no file action is taken: The output filename is not prompted for,
* the file is not created, if it exists it is not touched.
*
* The function TWAIN_MultipageCount can be called during or after
* writing a multipage file, it reports the number of images written to the file.
* See also TWAIN_AcquireCount and TWAIN_BlankDiscardCount for other info.
*
* Return values:
*   0  success
*  -1  the Acquire failed, or the device closed or quit after 0 pages.
*      If 0 pages were written but no other error was diagnosed,
*      TWAIN_LastErrorCode will be EZTEC_0_PAGES.
*  -2  file open error (invalid path or name, or access denied)
*  -3  could not load file-format module (EZTiff.dll or EZPdf.dll)
*      Either the DLL was not found, or the version is out-of-date,
*      For PDF output, EZJpeg.dll is also required.
*      Less likely: The device returned an invalid DIB handle, or
*      the transferred image has a bit depth of 9..15 bits per pixel (??)
*  -4  writing failed, possibly output device is full.
*  -7  Multipage support is not installed.
* -10  user cancelled - This can be during the filename prompt, if you
*      did not supply a filename, or it can be when the scanner dialog
*      is first displayed.  If the scanner dialog is visible, the user
*      can cancel during a scan and the dialog will just stay open (usually)
*      allowing another try.  If the user closed the scan dialog without
*      scanning, TWAIN_LastErrorCode will be EZTEC_USER_CANCEL.
*
* This function respects TWAIN_SetHideUI as follows:
* If SetHideUI(1), then the device UI is hidden, AcquireMultipageFile
* will transfer images until the device indicates that it has no
* more images ready.  (Technically, it goes to State 5).
* Exception: If a device seems to be one-image-at-a-time (such as a flatbed)
* the user will be asked if they want to acquire another image.
*
* If SetHideUI(0) [the default case] then the device UI is shown,
* and AcquireMultipageFile will transfer images until the user
* closes the device dialog.
*
* This function respects SetMultiTransfer() as follows:
* If SetMultiTransfer(1), the DS is left open on return.
* Otherwise (the default case), the DS is closed and TWAIN is unloaded.
*
* If you want to set scanning parameters (resolution, pixeltype...)
* first open the source (see OpenDefaultSource or OpenSource)
* then negotiate the settings using the Capability functions, and
* then call AcquireMultipageFile.
*
* Caution: It is not recommended to use this function on webcams
* if the UI is hidden.  Some will crash, others may supply images
* endlessly (until disk full.)

DECLARE LONG TWAIN_AcquireToArray IN Eztwain3.dll ;
   LONG hwnd, ;
   STRING @ahdib, ;
   LONG nMax
* Scan and store images in the specified array.
* Very similar to TWAIN_AcquireMultipageFile.
* A return value of N >= 0 means N images were scanned and stored
* without error.  (N=0 if the job ended without error after 0 pages.)
* Any unused entries in the array are set to 0 (NULL)
* In case of error, no images are returned - the scan must be restarted.

DECLARE LONG TWAIN_AcquireImagesToFiles IN Eztwain3.dll ;
   LONG hwndApp, ;
   STRING sFileName
* Similar to TWAIN_AcquireMultipageFile above, but writes each
* image to a separate file.  The format of the output files is
* determined by the extension of the filename, as with AcquireToFilename.
*
* If the filename is NULL or points to the null string, the user is
* prompted for the name of the first file.
*
* Files after the first are given names 'incremented' from the name
* of the first file according to this pattern:
* document.pdf increments to document1.pdf
* document99.pdf increments to document100.pdf
* document0001.tif increments to document0002.tif.
*
* Return values:
* IMPORTANT: If successful, returns the number of files written.
* Note that this could be 0 if the scanner dialog is displayed and
* the user closes the dialog without any scans.
* Otherwise, return value same as TWAIN_AcquireMultipageFile, and
* details available from TWAIN_LastErrorCode & related functions.
* 
* See also: TWAIN_AcquiredFileCount
*           TWAIN_AcquireCount
*           TWAIN_BlankDiscardCount.

DECLARE LONG TWAIN_AcquirePagesToFiles IN Eztwain3.dll ;
   LONG hwnd, ;
   LONG nPPF, ;
   STRING sFile
* Similar to AcquireImagesToFiles, but can acquire duplex or multipage files.
*
* hwnd     = parent window. Use 0 (NULL) if you can't obtain the window handle.
*
* nPPF     = *pages* per file.
*            If the scanner is scanning duplex, 1 page = 2 images
*            otherwise 1 page = 1 image.
*
* pzFile   = filename.  We recommend including the extension to specify the format.
*            If the filename is NULL or points to the empty string, the user is
*            prompted for the name of the first file.
*
* Return: If successful, returns the number of files written.
* Otherwise, same as TWAIN_AcquireMultipageFile, with
* details available from TWAIN_LastErrorCode & related functions.

DECLARE LONG TWAIN_AcquiredFileCount IN Eztwain3.dll
* Returns the number of files successfully written by the last call to
* TWAIN_AcquireImagesToFiles or TWAIN_AcquirePagesToFiles.

DECLARE LONG TWAIN_AcquireCompressed IN Eztwain3.dll ;
   LONG hwndApp
* Acquire the next available image from the open (or default) device,
* accepting a compressed memory transfer if one is selected.
* (Use TWAIN_SetCompression to select the compression algorithm.)
* 
* The DIB handle which is returned will normally reference a compressed
* DIB, which is acceptable to very few other EZTwain functions.
* See also: DIB_IsCompressed
*
* Recommended use of this function:
* Open a device with TWAIN_OpenSource or TWAIN_OpenDefaultSource.
* Set any other scanning parameters such as PixelType, resolution, etc.
* Select memory transfer mode, using TWAIN_SetXferMech.
* Select a compression algorithm, using TWAIN_SetCompression.
* Call this function (possibly in a loop) to acquire images.


DECLARE LONG TWAIN_AcquireCount IN Eztwain3.dll
* Returns the number of images acquired by the last call to
* TWAIN_AcquireMultipageFile, TWAIN_AcquireImagesToFiles,
* or TWAIN_AcquirePagesToFiles.
*
* This includes only "keeper" pages - it *excludes*
* any discarded blank pages, separator pages, etc.
*
* Therefore it may differ from the value of TWAIN_MultipageCount.

DECLARE LONG TWAIN_SetDefaultScanAnotherPagePrompt IN Eztwain3.dll ;
   LONG fYes
* Controls an aspect of TWAIN_AcquireMultipageFile - When used
* with a non-feeder device, with UI suppressed, that function
* asks the user if they want to scan another page, [Yes] or [No].
* This function controls which answer is the default:
* fYes = 1         [Yes] is the default button/answer*
* fYes = 0         [No] is the default button/answer.
*
* * EZTwain initial setting.
*  
* Return value: Previous value of the setting.

* Acquire callback/notification

DECLARE LONG TWAIN_AcquireFile IN Eztwain3.dll ;
   LONG hwndApp, ;
   LONG nFF, ;
   STRING sFileName
* Acquire an image directly to a file, using the given format and filename.
*
*---- Aliases for TWAIN File Formats
#DEFINE TWAIN_FF_TIFF 0
#DEFINE TWAIN_FF_PICT 1
#DEFINE TWAIN_FF_BMP 2
#DEFINE TWAIN_FF_XBM 3
#DEFINE TWAIN_FF_JFIF 4
#DEFINE TWAIN_FF_FPX 5
#DEFINE TWAIN_FF_TIFFMULTI 6
#DEFINE TWAIN_FF_PNG 7
#DEFINE TWAIN_FF_SPIFF 8
#DEFINE TWAIN_FF_EXIF 9
#DEFINE TWAIN_FF_PDF 10
#DEFINE TWAIN_FF_JP2 11
#DEFINE TWAIN_FF_JPN 12
#DEFINE TWAIN_FF_JPX 13
#DEFINE TWAIN_FF_DEJAVU 14
#DEFINE TWAIN_FF_PDFA 15
*
* * Unlike AcquireToFilename, this function uses TWAIN File Transfer Mode.
* * The image is written to disk by the Data Source, not by EZTWAIN.
* * Warning: This mode is -not- supported by all TWAIN devices.
* 
* Use TWAIN_SupportsFileXfer to see if the open DS supports File Transfer.
*
* You can use TWAIN_Get(ICAP_IMAGEFILEFORMAT) to get an enumeration of
* the available file formats, and CONTAINER_ContainsValue to check for
* a particular format you are interested in.
*
* If the filename is NULL or an empty string, this functions prompts for
* the file name in a standard Save File dialog.
*
* Note Boolean return value!
*  TRUE(1) for success
*  FALSE(0) for failure - use GetResultCode/GetConditionCode for details.
*  If the user cancels the Save File dialog, GetResultCode will be TWRC_CANCEL


DECLARE LONG TWAIN_DoSettingsDialog IN Eztwain3.dll ;
   LONG hwnd
* Run the device's settings dialog, if this is supported, and return
* when the user closes the dialog.  See return codes below.
*
* If a device is open, work with that device.  If no device is currently
* open, work with the default device.  (See GetDefaultSourceName)
* This is an *optional* TWAIN feature - To check if a device supports this,
* open the device and call TWAIN_GetCapBool(CAP_ENABLEDSUIONLY, FALSE) -
* if that call returns TRUE(1) then this feature is supported.
* Return values:
*    1     dialog was displayed and user clicked OK
*    0     dialog was displayed and user clicked Cancel
*   -1     dialog not displayed - some error.  Call LastErrorCode,
*          ReportLastError, or similar function for more details.

DECLARE LONG TWAIN_EnableSourceUiOnly IN Eztwain3.dll ;
   LONG hwnd
* The underlying 'asynchronous' function for TWAIN_DoSettingsDialog.
* Opens the device's settings dialog, if this is supported.
* Returns TRUE (1) if successful, FALSE (0) otherwise.
* NOTE: If successful, this call leaves the dialog open, so your
* program must run a message pump at least until the user closes it.
* If you don't understand what that means, don't call this guy.

*--------- Global Options

DECLARE TWAIN_SetMultiTransfer IN Eztwain3.dll ;
   LONG bYes
DECLARE LONG TWAIN_GetMultiTransfer IN Eztwain3.dll
* This function controls the 'multiple transfers' flag.
* By default, this feature is set to FALSE (0).
*
* If this flag is zero, the input device is closed when
* any TWAIN_AcquireXXX function finishes.
*
* If this flag is non-zero: After an Acquire, the input device
* is not closed, but is left open to allow additional images
* to be acquired.  In this case the programmer should
* close the input device after all images have been
* transferred, by calling either
*     TWAIN_CloseSource or
*     TWAIN_UnloadSourceManager
*
* See also: TWAIN_UserClosedSource()

DECLARE LONG TWAIN_WaitForImage IN Eztwain3.dll ;
   LONG hwnd
* ** Experimental - Use with caution **
*
* Returns TRUE(1) if TWAIN device is ready to deliver an image.
*   -- TWAIN_State() will be 6 in this case.
* Returns FALSE(1) if the application should stop acquiring and close the DS.
*
* If no device is open, the default device is opened.
* If the device is interacting with the user, waits for the user
* to either start a transfer, or close the device dialog.
* This function is primarily useful for multiple transfers, in loops like:
*     IF TWAIN_OpenDefaultSource() AND NegotiateSettings() THEN
*         WHILE TWAIN_WaitForImage(hwnd)
*             TWAIN_AcquireToFilename(hwnd, filename)
*             increment(filename)
*         END WHILE
*         TWAIN_CloseSource()
*     END IF

DECLARE TWAIN_SetHideUI IN Eztwain3.dll ;
   LONG bHide
DECLARE LONG TWAIN_GetHideUI IN Eztwain3.dll
* These functions control the 'hide source user interface' flag.
* This flag is cleared initially, but if you set it non-zero, then when
* a device is enabled it will be asked to hide its user interface.
* Note that this is only a request - some devices will ignore it!
* This affects AcquireNative, AcquireToClipboard, and EnableSource.
* If the user interface is hidden, you will probably want to set at least
* some of the basic acquisition parameters yourself - see
* SetUnits, SetPixelType, SetBitDepth and SetResolution below.
* See also: HasControllableUI

DECLARE TWAIN_DisableParent IN Eztwain3.dll ;
   LONG bYes
DECLARE LONG TWAIN_GetDisableParent IN Eztwain3.dll
* Set or get the "DisableParent" flag.
* When this flag is set (non-zero), EZTwain attempts to
* disable the parent window during any Acquire function.
* (The parent window is the window you pass to the Acquire function.
* Typically this is your main application window or dialog.)
* This flag is TRUE (1) by default.
*
* Note 1: If you set this to FALSE, your window can receive user input while
* an Acquire is in progress, and your code must be prepared for this.
* Note 2: Some TWAIN data sources will disable the parent window on their
* own, and EZTWAIN cannot prevent this.


*--------- Basic TWAIN Inquiries

DECLARE LONG TWAIN_EasyVersion IN Eztwain3.dll
* Returns the version number of EZTWAIN.DLL, multiplied by 100.
* So e.g. version 2.01 will return 201 from this call.
DECLARE LONG TWAIN_EasyBuild IN Eztwain3.dll
* Returns the build number within the version.

DECLARE LONG TWAIN_IsAvailable IN Eztwain3.dll
* Call this function any time to find out if TWAIN is installed on the
* system.  It takes a little time on the first call, after that it's fast,
* just testing a flag.  It returns 1 if the TWAIN Source Manager is
* installed & can be loaded, 0 otherwise. 

DECLARE LONG TWAIN_IsMultipageAvailable IN Eztwain3.dll
* Return TRUE (1) if EZTwain 'multipage' services are installed.
* This allows writing of multipage TIFF (if TIFF is available)
* and multipage PDF (if PDF is available).
* It also enables TWAIN_AcquireMultipageFile

DECLARE LONG TWAIN_State IN Eztwain3.dll
* Returns the TWAIN Protocol State per the spec.
#DEFINE TWAIN_PRESESSION 1
#DEFINE TWAIN_SM_LOADED 2
#DEFINE TWAIN_SM_OPEN 3
#DEFINE TWAIN_SOURCE_OPEN 4
#DEFINE TWAIN_SOURCE_ENABLED 5
#DEFINE TWAIN_TRANSFER_READY 6
#DEFINE TWAIN_TRANSFERRING 7

DECLARE LONG TWAIN_IsDone IN Eztwain3.dll
* Return TRUE (1) if there is a device open, and it is in
* the state that indicates that no more scans should be requested
* at this time.  This call can be used as the test at the *bottom*
* of a do-until loop, for multipage scanning:
*   If TWAIN_OpenDefaultSource() Then
*      TWAIN_SetMultiTransfer(1)
*      Do
*         TWAIN_AcquireToFilename(0, NextFileName())
*      Until TWAIN_IsDone()
*      TWAIN_CloseSource()
*   End If
*

DECLARE STRING TWAIN_SourceName IN Eztwain3.dll
* Returns a pointer to the name of the currently or last opened source.

DECLARE TWAIN_GetSourceName IN Eztwain3.dll ;
   STRING @sName
* Like TWAIN_SourceName, but copies current/last source name into its parameter.
* The parameter is a string variable (char array in C/C++).
* You are responsible for allocating room for 33 8-bit characters
* in the string variable before calling this function.

*--------- DIB handling utilities ---------

DECLARE LONG DIB_Depth IN Eztwain3.dll ;
   LONG hdib
DECLARE LONG DIB_BitsPerPixel IN Eztwain3.dll ;
   LONG hdib
* 'depth' of image - number of bits used to store one pixel

DECLARE LONG DIB_PixelType IN Eztwain3.dll ;
   LONG hdib
* TWAIN PixelType that describes this DIB: TWPT_BW, TWPT_GRAY, TWPT_RGB,
* TWPT_PALETTE, TWPT_CMYK, TWPT_CMY, etc.

DECLARE LONG DIB_Width IN Eztwain3.dll ;
   LONG hdib
* Width of DIB, in pixels (columns)
DECLARE LONG DIB_Height IN Eztwain3.dll ;
   LONG hdib
* Height of DIB, in lines (rows)

DECLARE DIB_SetResolution IN Eztwain3.dll ;
   LONG hdib, ;
   DOUBLE xdpi, ;
   DOUBLE ydpi
DECLARE DIB_SetResolutionInt IN Eztwain3.dll ;
   LONG hdib, ;
   LONG xdpi, ;
   LONG ydpi
* Sets the horizontal and vertical resolution of the DIB.

DECLARE DOUBLE DIB_XResolution IN Eztwain3.dll ;
   LONG hdib
* Horizontal (x) resolution of DIB, in DPI (dots per inch)
DECLARE DOUBLE DIB_YResolution IN Eztwain3.dll ;
   LONG hdib
* Vertical (y) resolution of DIB, in DPI (dots per inch)

DECLARE LONG DIB_XResolutionInt IN Eztwain3.dll ;
   LONG hdib
DECLARE LONG DIB_YResolutionInt IN Eztwain3.dll ;
   LONG hdib
* Return the nearest integer value to the x or y resolution of an image.

* Physical or 'implied' image size
DECLARE DOUBLE DIB_PhysicalWidth IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nUnits
DECLARE DOUBLE DIB_PhysicalHeight IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nUnits
* Return the width(height), in the specified units, of the given
* image, calculated using its pixel width(height) and X(Y) resolution.
* If the resolution is 0, these functions return 0.
* nUnits is one of the TWUN_ values - see TWAIN_GetCurrentUnits.
* nUnits=0 is inches, and nUnits=1 is centimeters(cm).

DECLARE LONG DIB_RowBytes IN Eztwain3.dll ;
   LONG hdib
* Number of bytes needed to store one row of the DIB.

DECLARE LONG DIB_ColorCount IN Eztwain3.dll ;
   LONG hdib
* Number of colors in color table of DIB.
* Primarily useful for B&W, gray, and palette images.
* 16-bit gray, RGB, CMY & CMYK images have no color table: DIB_ColorCount returns 0

DECLARE LONG DIB_SamplesPerPixel IN Eztwain3.dll ;
   LONG hdib
* Number of 'samples' or components or color channels in each pixel.
* B&W and gray pixels have 1 sample, RGB and CMY have 3.
* CMYK has 4, and palette-color images are treated as having 3 channels.

DECLARE LONG DIB_BitsPerSample IN Eztwain3.dll ;
   LONG hdib
* Number of bits per 'channel'.  For B&W and gray images this is
* the same as the DIB_Depth, because those formats have only one channel.
* For palette images, this will be 8, because the color values in a
* palette image are stored with 8 bits each for R, G, and B.
* For RGB, CMY, and CMYK images, this function returns the number of bits
* used to represent each color channel or component - almost always 8, but
* EZTwain has a limited ability to handle 16-bit per channel images.

DECLARE LONG DIB_IsCompressed IN Eztwain3.dll ;
   LONG hdib
* Return 1(True) if image is compressed in memory 0(False) otherwise.

DECLARE LONG DIB_Compression IN Eztwain3.dll ;
   LONG hdib
* Return the TWCP_xxx code representing the compression algorithm
* of this image.  Uncompressed images yield TWCP_NONE.



DECLARE LONG DIB_Size IN Eztwain3.dll ;
   LONG hdib
* Return the size in memory of the given DIB.

DECLARE DIB_ReadData IN Eztwain3.dll ;
   LONG hdib, ;
   STRING @pdata, ;
   LONG nbMax
* Read up to nbMax bytes from the given DIB into the given buffer.
* The data is read 'verbatim' from the first byte of the DIB.
* To read pixel data, see DIB_ReadRowxxx below.

DECLARE DIB_ReadRow IN Eztwain3.dll ;
   LONG hdib, ;
   LONG r, ;
   STRING @prow
DECLARE DIB_ReadRowRGB IN Eztwain3.dll ;
   LONG hdib, ;
   LONG r, ;
   STRING @prow
DECLARE DIB_ReadRowGray IN Eztwain3.dll ;
   LONG hdib, ;
   LONG r, ;
   STRING @prow
DECLARE DIB_ReadRowChannel IN Eztwain3.dll ;
   LONG hdib, ;
   LONG r, ;
   STRING @prow, ;
   LONG nChannel
DECLARE DIB_ReadRowSample IN Eztwain3.dll ;
   LONG hdib, ;
   LONG r, ;
   STRING @prow, ;
   LONG nSample
* Read row r of the given DIB into buffer at prow.
* Caller is responsible for ensuring buffer is large enough.
* ReadRowRGB always reads 3 bytes (24 bits) for each pixel,
* ReadRowGray and ReadRowChannel always read 1 byte (8 bits) per pixel.
* Row 0 is the *top* row of the image, as it would be displayed.
* The first variant reads the data exactly as-is from the DIB, including
* BGR pixels from 24-bit DIBs, 16-bit grayscale, 1-bit B&W, etc.
* The RGB variant unpacks every DIB pixel into 3-byte RGB pixels.
* The Gray variant converts every pixel to its 8-bit gray value.
* Channel codes are: 0=Gray(Luminance), 1=Red, 2=Green, 3=Blue.  See
* 'Component codes' below.
* Samples are the bytes of the pixel: A grayscale pixel has sample 0,
* an RGB image has samples 0, 1 and 2 (which are actually Green, Red and Blue).

DECLARE DIB_ReadPixelRGB IN Eztwain3.dll ;
   LONG hdib, ;
   LONG x, ;
   LONG y, ;
   STRING @buffer
DECLARE DIB_ReadPixelGray IN Eztwain3.dll ;
   LONG hdib, ;
   LONG x, ;
   LONG y, ;
   STRING @buffer
DECLARE DIB_ReadPixelChannel IN Eztwain3.dll ;
   LONG hdib, ;
   LONG x, ;
   LONG y, ;
   STRING @buffer, ;
   LONG nChannel
* Read the value of the pixel at column x row y of the DIB into the buffer.
* RGB form reads 3 bytes R,G,B
* Gray form reads 1 byte of 'equivalent gray'
* Channel form reads 1 byte of channel/component, see COMPONENT_xxx codes.


DECLARE DIB_WriteRow IN Eztwain3.dll ;
   LONG hdib, ;
   LONG r, ;
   STRING pdata
* Write data from buffer into row r of the given DIB.
* Caller is responsible for ensuring buffer and row exist, etc.

DECLARE DIB_WriteRowChannel IN Eztwain3.dll ;
   LONG hdib, ;
   LONG r, ;
   STRING pdata, ;
   LONG nChannel
* Write data from buffer into one color channel of row r of the given DIB.
* This function should only be used on 24-bit RGB, 32-bit RGBA, 24-bit CMY,
* 32-bit CMYK, or 8-bit grayscale images.  Its behavior on any other image is undefined.
* Channels are: 0=gray, 1=Red, 2=Green, 3=Blue, 4=Alpha or
* 1=C, 2=M, 3=Y, 4=K.

DECLARE DIB_WriteRowSample IN Eztwain3.dll ;
   LONG hdib, ;
   LONG r, ;
   STRING psrc, ;
   LONG nSample
* Write row of data into one sample of an image.
* Only handles 8-bit data and images with 1 or more samples of 8 bits each.
* Channels are somewhat logical properties of an image, samples are
* just the bytes in a pixel - sample 0 is byte 0, sample 1 is byte 1, etc.

* Safe versions of ReadRow and WriteRow, handy for .NET languages
DECLARE DIB_WriteRowSafe IN Eztwain3.dll ;
   LONG hdib, ;
   LONG r, ;
   STRING pdata, ;
   LONG nbMax
DECLARE DIB_ReadRowSafe IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nRow, ;
   STRING @prow, ;
   LONG nbMax

DECLARE LONG DIB_Allocate IN Eztwain3.dll ;
   LONG nDepth, ;
   LONG nWidth, ;
   LONG nHeight
* Create a DIB with the given dimensions.  Resolution is set to 0.  A default
* color table is provided if depth <= 8.
* The image data is uninitialized i.e. garbage.

DECLARE LONG DIB_Create IN Eztwain3.dll ;
   LONG nPixelType, ;
   LONG nWidth, ;
   LONG nHeight, ;
   LONG nDepth
* Create a DIB of the given pixel type and dimensions.
* If nDepth <= 0, uses the default depth for the given pixel type.
* Resolution is set to 0.
* For TWPT_GRAY images, a standard black-to-white color table is set.
* For TWPT_PALETTE images, a Windows-standard 256-entry color table is set.

DECLARE DIB_Free IN Eztwain3.dll ;
   LONG hdib
* Release the storage of the DIB.

*  under consideration for EZTwain 3.4 or 4.0
*void EZTAPI DIB_FreeAll(void);
*// Free all DIB handles created by EZTwain but not yet freed.
*// This is convenient at the end of a complex scanning function, if
*// you are not keeping any DIB images in memory: Call this
*// function and it cleans everything up.  This way you do not have to
*// individually free each DIB as soon as you are done with it.
*

DECLARE LONG DIB_InUseCount IN Eztwain3.dll
* Return the number of DIBs 'outstanding' - allocated but not disposed of.
* Note that a DIB that is put on the clipboard becomes the property of the
* clipboard and is considered 'disposed of'.
* This function can be used to detect leaks in application DIB management.

DECLARE LONG DIB_Copy IN Eztwain3.dll ;
   LONG hdib
* Create and return a byte-for-byte copy of a DIB.

DECLARE LONG DIB_Equal IN Eztwain3.dll ;
   LONG hdib1, ;
   LONG hdib2
* Return TRUE (1) if the two dibs are valid, have the same parameters,
* and are the same color pixel-for-pixel.

DECLARE LONG DIB_MaxError IN Eztwain3.dll ;
   LONG hdib1, ;
   LONG hdib2
* return the largest difference between two samples in the two images.

DECLARE DIB_SetGrayColorTable IN Eztwain3.dll ;
   LONG hdib
* Fill the DIB's color table with a gray ramp - so color 0 is black, and
* the last color (largest pixel value) is white.  No effect if depth > 8.
DECLARE DIB_SetColorTableRGB IN Eztwain3.dll ;
   LONG hdib, ;
   LONG i, ;
   LONG R, ;
   LONG G, ;
   LONG B
* Set the ith entry in the DIB's color table to the specified color.
* R G and B range from 0 to 255.

DECLARE LONG DIB_IsVanilla IN Eztwain3.dll ;
   LONG hdib
* TRUE if in this DIB, pixel value 0 means 'white'.
DECLARE LONG DIB_IsChocolate IN Eztwain3.dll ;
   LONG hdib
* TRUE if in this DIB, pixel value 0 means 'black'.

DECLARE LONG DIB_ColorTableR IN Eztwain3.dll ;
   LONG hdib, ;
   LONG i
DECLARE LONG DIB_ColorTableG IN Eztwain3.dll ;
   LONG hdib, ;
   LONG i
DECLARE LONG DIB_ColorTableB IN Eztwain3.dll ;
   LONG hdib, ;
   LONG i
* Return the R,G, or B component of the ith color table entry of a DIB.
* If i < 0 or >= DIB_ColorCount(hdib), returns 0.

DECLARE DIB_FlipVertical IN Eztwain3.dll ;
   LONG hdib
* Flip (mirror) the bitmap vertically.
* Top and bottom rows are exchanged, etc.

DECLARE DIB_FlipHorizontal IN Eztwain3.dll ;
   LONG hdib
* Flip (mirror) the bitmap horizontally.
* Leftmost pixels become rightmost, etc.

DECLARE DIB_Rotate180 IN Eztwain3.dll ;
   LONG hdib
* Rotate image 180 degrees

DECLARE LONG DIB_Rotate90 IN Eztwain3.dll ;
   LONG hOld, ;
   LONG nSteps
* Return a copy of hOld rotated clockwise nSteps * 90 degrees.
* If nSteps is 0, the result is a copy of hOld.
* Negative values of nSteps rotate counterclockwise.
* Note that *hOld is not destroyed*

DECLARE DIB_Fill IN Eztwain3.dll ;
   LONG hdib, ;
   LONG R, ;
   LONG G, ;
   LONG B
* Fill the DIB with the specified color

DECLARE DIB_FillRectWithColorAlpha IN Eztwain3.dll ;
   LONG hdib, ;
   LONG x, ;
   LONG y, ;
   LONG w, ;
   LONG h, ;
   LONG R, ;
   LONG G, ;
   LONG B, ;
   LONG A
* Fill the specified rectangle in the image with the specified color using transparency=A
* A = 0  is transparent (so the fill has no effect)
* A = 255 is opaque, 

DECLARE DIB_Negate IN Eztwain3.dll ;
   LONG hdib

DECLARE DIB_AdjustBC IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nB, ;
   LONG nC
* *** BETA - new in 3.08b8 - use with caution.
* Adjust the brightness and/or contrast of the image.
* nB and nC are -1000 to 1000, with a value of 0 meaning 'no change'.
* Positive nB push all pixels toward white, negative toward black.
* Positive nC push all pixels away from mid-value, toward black and white.
* Negative nC pushes all pixels toward the mid-value.
* Works on grayscale, RGB, CMY(K) images - no effect on B&W and palette.

DECLARE LONG DIB_AutoContrast IN Eztwain3.dll ;
   LONG hdib
* Automatically adjust the values in the image to make
* the dominant light color into white, and the primary dark tone into black.

DECLARE DIB_Convolve IN Eztwain3.dll ;
   LONG hdibDst, ;
   LONG hdibKernel, ;
   DOUBLE dNorm, ;
   LONG nOffset
* Apply hdibKernel as a convolution kernel to hdibDst.
* At each pixel in hdibDst, hdibKernel is convolved with the neighborhood
* and the result is stored back into hdibDst.
* The point value of the convolution is normalized by dividing by dNorm, and
* then nOffset is added, before clipping to the pixel range of hdibDst.

DECLARE DIB_Correlate IN Eztwain3.dll ;
   LONG hdibDst, ;
   LONG hdibKernel
* Similar to DIB_Convolve, but performs a correlation between hdibDst and hdibKernel,
* assuming that hdibKernel is image data (preferably grayscale), and putting
* the result into hdibDst.

DECLARE DIB_CrossCorrelate IN Eztwain3.dll ;
   LONG hdibDst, ;
   LONG hdibTemplate, ;
   DOUBLE dScale, ;
   LONG nMin
* Similar to DIB_Convolve, but performs a cross-correlation between hdibDst and hdibTemplate,
* assuming that hdibTemplate is grayscale image data, and putting
* the result into hdibDst.  In the output, a value of 255 signifies perfect correlation,
* 0 signifies perfect non-correlation (actually, a perfect opposite).
* All output values are divided by dScale.
* If nMin > 0, the correlation at each output pixel stops as soon as the value at that
* pixel is known to be <= nMin.  If you know that the values of interest are (say) > 200,
* setting a dMin of 128 can speed up the correlation greatly.

DECLARE DIB_HorizontalDifference IN Eztwain3.dll ;
   LONG hdib

DECLARE DIB_HorizontalCorrelation IN Eztwain3.dll ;
   LONG hdib
DECLARE DIB_VerticalCorrelation IN Eztwain3.dll ;
   LONG hdib

DECLARE DIB_MedianFilter IN Eztwain3.dll ;
   LONG hdib, ;
   LONG W, ;
   LONG H, ;
   LONG nStyle
* Apply a median filter to hdib using an W x H neighborhood.
* nStyle is currently ignored, but should be 0 for future compatibility.

DECLARE DIB_MeanFilter IN Eztwain3.dll ;
   LONG hdib, ;
   LONG W, ;
   LONG H
* Replace each pixel with the average of a W x H pixel neighborhood.
* We recommend you use odd value for W and H.

DECLARE DIB_Smooth IN Eztwain3.dll ;
   LONG hdib, ;
   DOUBLE sigma, ;
   DOUBLE opacity
* Apply a (gaussian) smoothing filter to the image.
* sigma is the controlling parameter of the Gaussian
* G(x,y) = exp(-(x^2+y^2) / 2*sigma^2) / (2 * pi * sigma^2)
* opacity is the fraction of the filter output that is blended
* back into the image i.e. out = in*(1-opacity) + f(in)*opacity

DECLARE LONG DIB_ScaledCopy IN Eztwain3.dll ;
   LONG hOld, ;
   LONG w, ;
   LONG h
* Create and return a new image - which is a copy of hOld
* but scaled (resampled) to have width w and height h.
* The input image must be of type TWPT_BW, TWPT_GRAY, or TWPT_RGB.
* If the input image is of type TWPT_BW, the returned image will be
* 8-bit grayscale.
* Otherwise the output image has the same type and depth as the input.
* *Don't forget to DIB_Free the old DIB when you are done with it.

DECLARE LONG DIB_ScaleToGray IN Eztwain3.dll ;
   LONG hdibOld, ;
   LONG nRatio
* Create and return a new DIB containing the hdibOld image
* converted to grayscale and reduced in width & height by nRatio.
* Works well on B&W images.

DECLARE LONG DIB_Thumbnail IN Eztwain3.dll ;
   LONG hdibSource, ;
   LONG MaxWidth, ;
   LONG MaxHeight
* Return a DIB containing a copy of hdibSource, scaled so that its width
* is no more than MaxWidth, and height is no more than MaxHeight.
* B&W images are converted to grayscale thumbnails.
* Remember to DIB_Free hdibSource and the thumbnail, when you are done with them.

DECLARE LONG DIB_Resample IN Eztwain3.dll ;
   LONG hOld, ;
   DOUBLE xdpi, ;
   DOUBLE ydpi
* Return a new image which is a copy of the old image, but resampled
* to the specified resolution.
* "Resampling" is the technical term for recomputing the pixels of
* an image, when you want to change the number of pixels in the image
* but not the physical size (like 8.5" x 11").
* If you resample from 300DPI to 100DPI, you will have 1/3 as many rows,
* 1/3 as many columns, 1/9 as many pixels - but the pixels will be
* marked in the image as being 3 times as 'wide' and 'tall' - so the
* physical size of the image stays the same.
* This is the same as DIB_ScaledCopy, just looked at in a different way.
* DIB_Resample will fail if the input image as either resolution <= 0,
* or if either xdpi or ydpi is <= 0.  It can also fail with insufficient memory.
* Remember to DIB_Free the old DIB when you are done with it.

DECLARE LONG DIB_RegionCopy IN Eztwain3.dll ;
   LONG hOld, ;
   LONG leftx, ;
   LONG topy, ;
   LONG w, ;
   LONG h, ;
   LONG FillByte
* Create and return a portion of DIB hOld.  The copied region is a rectangle
* w pixels wide, h pixels high, starting at (x, y) in the hOld image,
* where (0,0) is the upper-left corner of hOld, visually.
* Pixels that don't fit into the new DIB are discarded.
* (So this function can be used to crop an image.)
* If the new DIB is taller or wider than the old, the new
* pixels are filled with bytes = fill.  Common values for
* fill are:
*                                 -1 (or 255 or 0xFF) which fills with 1's producing white
*   0 which produces black fill.

DECLARE LONG DIB_AutoCrop IN Eztwain3.dll ;
   LONG hOld, ;
   LONG nOptions
* Return a copy of the image in hOld, with the surrounding border
* of uniform color (if there is one) removed.
* Uses RegionCopy (above).
* After this call, remember to DIB_Free(hOld) if you don't need it.
* nOptions is currently unused and must be 0 (zero).

#DEFINE AUTOCROP_DARK 1
#DEFINE AUTOCROP_LIGHT 2
#DEFINE AUTOCROP_EDGE 4

DECLARE LONG DIB_GetCropRect IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nOptions, ;
   LONG @cropx, ;
   LONG @cropy, ;
   LONG @cropw, ;
   LONG @croph
* Return a suggested crop rectangle to remove a dark border from the image.
* The rectangle is defined by an upper-left point and a width and height, in pixels.
* (As needed by DIB_RegionCopy above.)
* nOptions is currently unused and must be 0.
* DIB_AutoCrop uses this function to decide what to crop.
* A return of FALSE means no crop rectangle was found - generally this means
* that the image has content that extends to the edges, or has no definite borders
* of dark color.  For convenience, when this function returns FALSE it
* still returns a valid crop rectangle containing the entire image.

DECLARE LONG DIB_AutoDeskew IN Eztwain3.dll ;
   LONG hOld, ;
   LONG nOptions
* Returns a copy of the image in hOld, possibly 'deskewed'.
* If it can be determined that the input image is consistently
* skewed (rotated by a small angle) then the returned image is rotated
* to eliminate that skew.
* The depth and pixel type of the image are not changed.
* The dimensions of the returned image may be slightly changed.
* nOptions is currently unused and must be 0 (zero).

DECLARE DOUBLE DIB_DeskewAngle IN Eztwain3.dll ;
   LONG hdib
* Compute and return the small clockwise rotation that would best
* 'deskew' the given image.  The return value is that angle
* in radians.  Only rotations in the range +-4 degrees are considered.

DECLARE DIB_SkewByDegrees IN Eztwain3.dll ;
   LONG hdib, ;
   DOUBLE dAngle
* Skew the given image clockwise in place by the specified angle (in degrees)

DECLARE LONG DIB_ConvertToPixelType IN Eztwain3.dll ;
   LONG hOld, ;
   LONG nPT
* Create and return a new DIB containing the hOld image converted
* to the specified pixel type.  Supported pixel types are:
* TWPT_BW, TWPT_GRAY, TWPT_RGB, TWPT_PALETTE, TWPT_CMY or TWPT_CMYK.
* When converting to black & white (TWPT_BW) the default conversion
* is simple thresholding - each pixel is converted to grayscale,
* then values 0..127 => Black, 128..255 => White.

DECLARE LONG DIB_ConvertToFormat IN Eztwain3.dll ;
   LONG hOld, ;
   LONG nPT, ;
   LONG nBPP
* Create and return a new DIB containing the hOld image converted
* to the specified pixel type and bits per pixel.
* Unsupported and impossible combinations cause a NULL return.

DECLARE LONG DIB_SmartThreshold IN Eztwain3.dll ;
   LONG hdib
* Apply automatic, adaptive thresholding to hdib, return
* the resulting 1-bit image.  This function is optimized for
* thresholding scanned text.
* ** Remember to free the input image if you are done with it.

DECLARE LONG DIB_SimpleThreshold IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nT
* Threshold hdib against nT and return the resulting 1-bit image.
* nT should be in the range 0 to 255.
* Pixels that are darker than nT become black in the output,
* pixels that are equal to or lighter than nT become white.
* ** Remember to free the input image if you are done with it.

DECLARE LONG DIB_SetConversionThreshold IN Eztwain3.dll ;
   LONG nT
DECLARE LONG DIB_ConversionThreshold IN Eztwain3.dll
* Set/Get the threshold used by DIB_ConvertToPixelType above
* when converting to B&W.  The default value is 128 which means '50%'.
* Pixels lighter than 50% => white, darker => black.
* DIB_SetConversionThreshold returns the previous value of the threshold.

DECLARE LONG DIB_FindAdaptiveGlobalThreshold IN Eztwain3.dll ;
   LONG hdib
* Find the adaptive threshold for input image

DECLARE LONG DIB_ErrorDiffuse IN Eztwain3.dll ;
   LONG hdib
* Create and return a new DIB containing the input image rendered
* to 1-bit B&W using error diffusion. The input image is not modified.

DECLARE DIB_SetConversionColorCount IN Eztwain3.dll ;
   LONG n
DECLARE LONG DIB_ConversionColorCount IN Eztwain3.dll
* Set/Get the number of colors that will be used in the next
* call to DIB_ConvertToPixelType or DIB_ConvertToFormat, if
* the output type is TWPT_PALETTE.

DECLARE DIB_SwapRedBlue IN Eztwain3.dll ;
   LONG hdib
* For 24-bit DIB only, exchange R and B components of each pixel.

DECLARE LONG DIB_CreatePalette IN Eztwain3.dll ;
   LONG hdib
* Create and return a logical palette to be used for drawing the DIB.
* For 1, 4, and 8-bit DIBs the palette contains the DIB color table.
* For 24-bit DIBs, a default halftone palette is returned.

DECLARE DIB_SetColorModel IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nCM
DECLARE LONG DIB_ColorModel IN Eztwain3.dll ;
   LONG hdib
#DEFINE EZT_CM_RGB 0
#DEFINE EZT_CM_GRAY 3
#DEFINE EZT_CM_CMYK 5

DECLARE DIB_SetColorCount IN Eztwain3.dll ;
   LONG hdib, ;
   LONG n

DECLARE DIB_Blt IN Eztwain3.dll ;
   LONG hdibDst, ;
   LONG dx, ;
   LONG dy, ;
   LONG hdibSrc, ;
   LONG sx, ;
   LONG sy, ;
   LONG w, ;
   LONG h, ;
   LONG uRop
* Transfer pixels from hdibSrc into hdibDst, starting at
* (dx,dy) in the destination, and (sx,sy) in the source,
* and transferring w columns x h rows.
* Any pixels that fall outside the actual bounds of the source
* and destination DIBs are ignored.
* The operations available are:
#DEFINE EZT_ROP_COPY 0
#DEFINE EZT_ROP_OR 1
#DEFINE EZT_ROP_AND 2
#DEFINE EZT_ROP_XOR 3
#DEFINE EZT_ROP_ANDNOT 18

DECLARE DIB_BltMask IN Eztwain3.dll ;
   LONG hdibDst, ;
   LONG dx, ;
   LONG dy, ;
   LONG hdibSrc, ;
   LONG sx, ;
   LONG sy, ;
   LONG w, ;
   LONG h, ;
   LONG uRop, ;
   LONG hdibMask
* Like DIB_Blt, but hdibMask contains an 8-bit alpha mask that controls
* how hdibSrc and hdibDst pixels are blended.  hdibMask must be the
* same size as hdibSrc, and be 8-bits deep.
* NOTE: The only uRop currently supported is EZT_ROP_COPY

DECLARE DIB_PaintMask IN Eztwain3.dll ;
   LONG hdibDst, ;
   LONG dx, ;
   LONG dy, ;
   LONG R, ;
   LONG G, ;
   LONG B, ;
   LONG sx, ;
   LONG sy, ;
   LONG w, ;
   LONG h, ;
   LONG uRop, ;
   LONG hdibMask
* Like DIB_BltMask - but paints a solid color into the destination DIB
* using hdibMask as a mask or stencil.  The mask must be an 8-bit
* grayscale image. The each mask pixel controls how much paint is mixed
* into the corresponding destination pixel: white=100%, black=0%.
* if w == -1 or h == -1 it means "as much as possible"
* NOTE: The only uRop currently supported is EZT_ROP_COPY
* See the User Guide for details.

DECLARE DIB_DrawLine IN Eztwain3.dll ;
   LONG hdibDst, ;
   LONG x1, ;
   LONG y1, ;
   LONG x2, ;
   LONG y2, ;
   LONG R, ;
   LONG G, ;
   LONG B

DECLARE DIB_DrawText IN Eztwain3.dll ;
   LONG hdibDst, ;
   STRING sText, ;
   LONG leftx, ;
   LONG topy, ;
   LONG w, ;
   LONG h
* Draw the text string into the DIB inside the given rectangle.
* If w or h is 0, the rectangle is extended to the bottom or right of the DIB.
* Default height is 14 pixels.  Default typeface is "Arial".
* Default color is black (R=G=B=0)
* See the following functions to override the default text settings.

* The following functions modify the default settings for DIB_DrawText:
DECLARE DIB_SetTextColor IN Eztwain3.dll ;
   LONG R, ;
   LONG G, ;
   LONG B

DECLARE DIB_SetTextAngle IN Eztwain3.dll ;
   LONG nDegrees
* Set the rotation of text within the drawing rectangle, clockwise.
* NOTE: Currently only multiples of 90 degrees are supported.

DECLARE DIB_SetTextHeight IN Eztwain3.dll ;
   LONG nH
* Set the text character height in pixels.
* If you want to set the text height in physical units (inches)
* multiply the physical height in inches by the DIB_YResolution.
* Note! Some files have resolution=0, which can often be treated as 72dpi

DECLARE DIB_SetTextFace IN Eztwain3.dll ;
   STRING sTypeface
* Specify a typeface - Use a typeface that is available on the host system,
* or use a standard face such as Arial, MS San Serif, MS Serif.
* You can also specify "Courier" or "Times" as shortcuts for the classic
* fixed-width and serif fonts.
* Passing NULL or the empty string resets to the default face ("Arial")

DECLARE DIB_SetTextFormat IN Eztwain3.dll ;
   LONG nFlags
* Sets text format according to the following flags.  The default
* format is normal, top, left
#DEFINE EZT_TEXT_NORMAL 0
#DEFINE EZT_TEXT_BOLD 1
#DEFINE EZT_TEXT_ITALIC 2
#DEFINE EZT_TEXT_UNDERLINE 4
#DEFINE EZT_TEXT_STRIKEOUT 8
#DEFINE EZT_TEXT_BOTTOM 256
#DEFINE EZT_TEXT_VCENTER 512
#DEFINE EZT_TEXT_TOP 0
#DEFINE EZT_TEXT_LEFT 0
#DEFINE EZT_TEXT_CENTER 4096
#DEFINE EZT_TEXT_RIGHT 8192
#DEFINE EZT_TEXT_WRAP 16384

DECLARE DIB_SetTextBackgroundColor IN Eztwain3.dll ;
   LONG R, ;
   LONG G, ;
   LONG B, ;
   LONG A
* Set the text background color, including transparency (alpha).
* RGB are color components, 0..255
* A is the alpha channel, from 0=100% transparent to 255=100% opaque.

*/////////////////////////////////////////////////////////////////////
* Image viewing services

DECLARE LONG DIB_View IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sTitle, ;
   LONG hwndParent
* Display the given image in a window with the given title.
* hwndParent is the window handle of the parent window - if you
* use 0 (NULL) for this parameter, EZTwain uses the active window
* of the application if there is one, or no parent window.
* By default, the window contains just an [OK] button.
* The style of the window is a resizable dialog box.
* 0    = the [Cancel] button was pressed.
* 1    = the [OK] button was pressed.

DECLARE LONG DIB_SetViewOption IN Eztwain3.dll ;
   STRING sOption, ;
   STRING sValue
* Same as TWAIN_SetViewOption.

DECLARE LONG DIB_SetViewImage IN Eztwain3.dll ;
   LONG hdib
* If the image viewer is open, change the displayed image to this one.

DECLARE LONG DIB_IsViewOpen IN Eztwain3.dll
* Return True if the image-view window is open, False otherwise.
* Note that the image viewer can be hidden, so it could be open
* and not be visible.

DECLARE LONG DIB_ViewClose IN Eztwain3.dll
* Close the image viewer window, if it is open.
* Only applies if the image viewer has been opened with the modeless option.
* Same as TWAIN_ViewClose.

DECLARE DIB_DrawOnWindow IN Eztwain3.dll ;
   LONG hdib, ;
   LONG hwnd
* Draw the DIB on the window.
* The image is scaled to just fit inside the window, while
* keeping the correct aspect ratio.  Any part of the window
* not covered by the image is left untouched (so it will normally
* be filled with the window's background color.)

DECLARE DIB_DrawToDC IN Eztwain3.dll ;
   LONG hdib, ;
   LONG hDC, ;
   LONG dx, ;
   LONG dy, ;
   LONG w, ;
   LONG h, ;
   LONG sx, ;
   LONG sy
* Draws DIB on a device context.
* You should call CreateDibPalette, select that palette
* into the DC, and do a RealizePalette(hDC) first.

*/////////////////////////////////////////////////////////////////////
* Printing services

DECLARE LONG DIB_SpecifyPrinter IN Eztwain3.dll ;
   STRING sPrinterName
* Specify the printer to be used when printing to the 'default printer'
* with the following functions.
* This does not change the user's default printer - it just tells
* EZTwain which printer to use as 'default'.
* Setting the printer name to NULL or the empty string tells EZTwain to
* use the user's default printer as its default printer.

DECLARE LONG DIB_EnumeratePrinters IN Eztwain3.dll
* Return the number of available printers

DECLARE STRING DIB_PrinterName IN Eztwain3.dll ;
   LONG i
* Return the name of the ith available printer, as found
* by a previous call to DIB_EnumeratePrinters.

DECLARE LONG DIB_GetPrinterName IN Eztwain3.dll ;
   LONG i, ;
   STRING @PrinterName
* Get the name of the ith available printer, as found by a previous
* call to DIB_EnumeratePrinters.
* You must allocate 256 characters for the printer name, and in many
* languages (especially Basic dialects) you must initialize the
* PrinterName variable with 256 spaces.

DECLARE DIB_SetPrintToFit IN Eztwain3.dll ;
   LONG bYes
DECLARE LONG DIB_GetPrintToFit IN Eztwain3.dll
* Get/Set the 'Print To Fit' flag.
* When this flag is non-zero, EZTwain reduces the size of images
* to fit within the printer page.  This only affects images that
* are too large to fit on the page.
* By default, this flag is FALSE (0)

DECLARE LONG DIB_Print IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sJobname
* Prompt the user with a Print Dialog, then print the DIB.
* Normally prints the DIB at 'actual size' - meaning the resolution
* values are used to convert the width and height from pixels to physical
* units (e.g. inches.)
* If the PrintToFit flag (see DIB_SetPrintToFit) is set and the image
* is larger than the printer page, the image is scaled to fit on the page.
* If the DIB has resolution values of 0, 72 DPI is assumed.
* The image is printed centered on the page.
* Return values:
*   0  success, no error
*  -2  specified printer not recognized or could not be opened
*  -3  invalid DIB handle (null, or DIB has been freed, or isn't a DIB handle)
*  -4  could not start document or start page error during printing
* -10  user cancelled a dialog (probably the Print dialog)

DECLARE LONG DIB_PrintNoPrompt IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sJobname
* Identical to DIB_Print, but prints on the default printer with
* default settings - the user is not prompted.


DECLARE LONG TWAIN_PrintFile IN Eztwain3.dll ;
   STRING sFilename, ;
   STRING sJobname, ;
   LONG bNoPrompt
DECLARE LONG DIB_PrintFile IN Eztwain3.dll ;
   STRING sFilename, ;
   STRING sJobname, ;
   LONG bNoPrompt
* Print the specified file as a print job with the specified job name.
* If the filename is null or empty, the user is prompted to select a file.
* If the jobname is null or empty, the actual filename is used as the jobname.
* If bNoPrompt is non-zero (True) the job is sent to the default printer,
* If bNoPrompt is zero (False) the user is prompted with the standard Print dialog.

* Printing - Multi-Page
*

DECLARE LONG DIB_PrintArray IN Eztwain3.dll ;
   STRING @ahdib, ;
   LONG nCount, ;
   STRING sJobname, ;
   LONG bNoPrompt
* Print the first nCount images in the array ahdib, under the given print-job name.
*
* If the job-name parameter is NULL or the empty string, the application title is used.
* If bNoPrompt is TRUE(non-zero), prints to the default printer without prompting the user,
* If bNoPrompt is FALSE(0) this function displays the standard print dialog.
*
* Return value is same as DIB_Print above.

DECLARE DIB_SetNextPrintJobPageCount IN Eztwain3.dll ;
   LONG nPages
* If you are about to call DIB_PrintJobBegin, you can call this function
* *before* calling that one, to set the page count for the next print job.
* This allows the print dialog to enable the page-range controls, so the
* user can designate a range of pages to print.
*
* Do not call this function unless you are calling DIB_PrintJobBegin directly.
*
* A page count of 0 or less means 'unknown page count', which disables
* the page-range controls.
* If you enable print-range selection in the print dialog, EZTwain
* automatically suppresses printing of all non-selected pages.

DECLARE LONG DIB_PrintJobBegin IN Eztwain3.dll ;
   STRING sJobname, ;
   LONG bUseDefaultPrinter
* Begin creating a multi-page print job.
*
* Jobname is the name of the print job.
* The jobname appears in the job-queue of the printer.
* In some environments it also appears on a job-separator
* page that is printed out ahead of each job.
* If Jobname is null or empty, the application title is used.
* (See TWAIN_SetAppTitle)
*
* If bUseDefaultPrinter is true (non-zero) the default printer
* is used, otherwise the user is prompted with a standard Print dialog.
*
* If you have called DIB_SetNextPrintJobPageCount (above) then the print
* dialog will offer the user the option of specifying a range of pages
* to print.  Otherwise that option is disabled and all pages are printed.
*
* If there is already a print job open when this function is called,
* it calls DIB_PrintJobEnd() to close that job before starting the new one.
*
* Return values:
*  0       success
* -2       could not open/access printer
* -4       printing output error
*-10       user cancelled Print dialog

DECLARE LONG DIB_PrintPage IN Eztwain3.dll ;
   LONG hdib
* Add a page to the current print job.
*
* Only valid after a successful call to DIB_PrintJobBegin and
* before the matching DIB_PrintJobEnd.
*
* See DIB_Print for more details.
*  0       success
* -3       the DIB is null or invalid
* -4       printing output error
* -5       no print job is open

DECLARE LONG DIB_PrintJobEnd IN Eztwain3.dll
* End the current print job and release it for printing.
* (Some environments will start printing as soon as a page is available.)
*  0       success
* -4       printing output error
* -5       no print job is open

*/////////////////////////////////////////////////////////////////////
* Clipboard functions
*
DECLARE LONG DIB_PutOnClipboard IN Eztwain3.dll ;
   LONG hdib
* Place DIB on the clipboard (format CF_DIB)
* ** IMPORTANT ** After this call, the clipboard owns the
* DIB and you do not - do not attempt any
* further operations on the hdib handle.
* Treat this call just as you would a call to DIB_Free.
* Returns TRUE(1) for success, FALSE(0) otherwise.

DECLARE LONG DIB_CanGetFromClipboard IN Eztwain3.dll
* Return TRUE(1) if there is something on the clipboard that
* can be delivered as a DIB (by DIB_GetFromClipboard below.)
* Return FALSE(0) if not.

DECLARE LONG DIB_GetFromClipboard IN Eztwain3.dll
DECLARE LONG DIB_FromClipboard IN Eztwain3.dll
* Create and return a DIB with the contents of the clipboard.
* This is the first step of a 'paste' function for images.
* Returns NULL in case of error, or if no image on clipboard.

* Working with a DIB through a DC
*
DECLARE LONG DIB_OpenInDC IN Eztwain3.dll ;
   LONG hdib, ;
   LONG hdc
DECLARE DIB_CloseInDC IN Eztwain3.dll ;
   LONG hdib, ;
   LONG hdc

* DIB File I/O
*
DECLARE LONG DIB_WriteToFilename IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
* Write image to file, using format implied by the filename extension.
*
* If the filename is NULL or points to a null string, the user is
* prompted for the filename and format with a standard Windows
* file-save dialog.
*
* If the final filename has a standard extension (.bmp, .jpg, .jpeg, .tif,
* .tiff, .png, .pdf, .gif, .dcx) then the file is saved in that format.
* Otherwise, the current SaveFormat is used - see TWAIN_SetSaveFormat.
*
* Return values:
*                                  0                                success
*                                 -1                                user cancelled File Save dialog
*                                 -2                                file open error (invalid path or name, or access denied)
*                                 -3                                a) image is invalid (null or invalid DIB handle)
*      b) support for the save format is not configured
*      c) DIB format incompatible with save format e.g. B&W to JPEG.
*                                 -4                                writing data failed, possibly output device is full
*  -5  other unspecified internal error

DECLARE LONG DIB_WriteToBmp IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
DECLARE LONG DIB_WriteToBmpFile IN Eztwain3.dll ;
   LONG hdib, ;
   LONG fh
DECLARE LONG DIB_WriteToJpeg IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
DECLARE LONG DIB_WriteToPng IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
DECLARE LONG DIB_WriteToTiff IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
DECLARE LONG DIB_WriteToPdf IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
DECLARE LONG DIB_WriteToGif IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
DECLARE LONG DIB_WriteToDcx IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
* Note: a return value of -3 indicates an invalid hdib handle, or
* 'no support for this format'.  -3 is also returned when attempting
* to write a Jpeg file from an image that is not 24-bit color or
* 8-bit grayscale.  1-bit B&W images cannot be saved as JPEG.
* 24-bit color images are 'quantized' to 8-bit color when written to GIF.
* All image types are converted to 1-bit B&W when written to DCX.
* Other internal errors will return -5, including insufficient memory.
* Check TWAIN_LastErrorCode for more details (maybe)

DECLARE LONG DIB_LoadFromFilename IN Eztwain3.dll ;
   STRING sFileName
* Load an image from a file and return its handle.
* The file can be in any format supported by EZTwain Pro.
* If the file is multipage, normally this function loads page 0,
* but a preceding call to DIB_SelectPageToLoad changes that.
* A return of NULL(0) indicates failure, see TWAIN_LastErrorCode
* and related functions for more details.
* If the filename is an empty string (or NULL) the user is prompted
* with a standard file-open dialog.
* EZTwain should read any variant of its supported formats,
* except for PDF: We only claim to support reading images
* from PDFs if they were created by EZTwain Pro.

DECLARE LONG DIB_FormatOfFile IN Eztwain3.dll ;
   STRING sFileName
* Returns the EZT_FF_ code for the format of the specified file.
* A return < 0 indicates 'unrecognized format' or some error
* when opening or reading the file.

DECLARE DIB_SelectPageToLoad IN Eztwain3.dll ;
   LONG nPage
* For use when loading multipage files.  Tells DIB_LoadFromFilename
* and DIB_LoadFromBuffer which page to load next, from a multipage file.
* Default is page 0 (first page in file).
* This value is reset to 0 after any call that tries to load a page.

DECLARE LONG DIB_GetFilePageCount IN Eztwain3.dll ;
   STRING sFileName
DECLARE LONG DIB_FilePageCount IN Eztwain3.dll ;
   STRING sFileName
* Return the number of pages in the specified file.
* If the file is a recognized multipage format
* (TIFF, PDF, DCX), the pages in the file are counted.
* All other recognized formats return a page count of 1.
* If the file cannot be opened, read, recognized, etc.
* this function records an error and returns -1.

DECLARE LONG DIB_LoadPage IN Eztwain3.dll ;
   STRING sFileName, ;
   LONG nPage
* Short for DIB_SelectPageToLoad, DIB_LoadFromFilename.
* Load the specified page from the specified file.
* Page 0 is the first page in a file.  Multiple
* pages are only supported in TIFF, PDF and DCX files, all other file
* formats have a single page, page #0.

DECLARE LONG DIB_LoadArrayFromFilename IN Eztwain3.dll ;
   STRING @ahdib, ;
   LONG nMax, ;
   STRING sFilename
* Load up to nMax images as DIBs into an array, reading from the specified file.
* If filename is null or the empty string, the user is prompted to select a file.
*
* If the user is prompted and cancels, this function returns -10.
* Otherwise if successful it returns the number of pages (images) loaded.
* Otherwise it returns -1 and you should call TWAIN_ReportLastError, TWAIN_LastErrorCode,etc.
*
* If this function returns < 0, the first nMax entries of the DIB array will be NULL (0).
* If returns N >= 0, the first N entries of the DIB array will
* contain handles to DIBs representing the first N images in the file.
* The remaining nMax-N entries in the DIB array will be NULL (0).
*
* Make sure you eventually call DIB_Free on all the loaded DIBs!

DECLARE LONG DIB_LoadPagesFromFilename IN Eztwain3.dll ;
   STRING @ahdib, ;
   LONG index0, ;
   LONG nMax, ;
   STRING sFilename
* Load up to nMax images from a specified file (or URL), starting at page index0.
* Remember pages are indexed from 0.
* Returns the number of images loaded - which can be 0 if there are no images
* in the file within the specified range.
* Returns -1 in case of error, call TWAIN_LastErrorCode & co. for more details.

DECLARE LONG DIB_FormatOfBuffer IN Eztwain3.dll ;
   STRING pBuffer, ;
   LONG nBytes
* Assuming the buffer contains something like an image file, return
* the format implied by the leading bytes.
* nBytes = number of bytes of data in buffer.

DECLARE LONG DIB_PageCountOfBuffer IN Eztwain3.dll ;
   STRING pBuffer, ;
   LONG nBytes
DECLARE LONG DIB_BufferPageCount IN Eztwain3.dll ;
   STRING pBuffer, ;
   LONG nBytes
* Assuming the buffer contains something like an image file, return
* the number of pages (images technically) in it.
* nBytes = number of bytes of data in buffer.

DECLARE LONG DIB_LoadFromBuffer IN Eztwain3.dll ;
   STRING pBuffer, ;
   LONG nBytes
* Load an image from a buffer, presumably formatted like an image file.
* If DIB_SelectPageToLoad was called just before, the
* designated page is loaded from the buffer.
* nBytes = number of bytes of data in buffer.

DECLARE LONG DIB_LoadPageFromBuffer IN Eztwain3.dll ;
   STRING pBuffer, ;
   LONG nBytes, ;
   LONG nPage
* Load the specified page from a buffer - the buffer must contain an image
* file.  If the image format is one that can hold only one image, the page
* number is ignored.
* nBytes = number of bytes of data in buffer.

DECLARE LONG DIB_LoadArrayFromBuffer IN Eztwain3.dll ;
   STRING @ahdib, ;
   LONG nMax, ;
   STRING pBuffer, ;
   LONG nBytes
* Load up to nMax images as DIBs into an array, reading from a file in memory.
* pBuffer is the address of the buffer (memory block) holding the file to read.
* nBytes is the number of bytes of data in the buffer.
*
* Returns the number of images loaded if successful, otherwise
* it returns -1 and you should call TWAIN_ReportLastError, TWAIN_LastErrorCode, or similar.
*
* Make sure you eventually call DIB_Free on all the loaded DIBs.

DECLARE LONG DIB_LoadFaxData IN Eztwain3.dll ;
   LONG hdib, ;
   STRING pBuffer, ;
   LONG nBytes, ;
   LONG nFlags
* Load a DIB's contents from a buffer of CCITT fax-encoded data.
* pBuffer is the address of the buffer in memory.
* nBytes is the number of bytes of data in the buffer.
* nFlags are decoding options:
* Override with flags:
#DEFINE FAX_GROUP3_2D 32
#DEFINE FAX_GROUP4 64
#DEFINE FAX_BYTE_ALIGNED 128
#DEFINE FAX_REQUIRE_EOLS 256
#DEFINE FAX_EXPECT_EOB 512
#DEFINE FAX_VANILLA 1024
* default is Group3 1D, chocolate, not byte-aligned, EOLs not required, EOB not expected.


DECLARE LONG DIB_WriteToBuffer IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nFormat, ;
   STRING @pBuffer, ;
   LONG nbMax
* Write the image into the buffer in the format, not more than nbMax bytes.
* The return value is the actual size of the image - this may be more or less
* than nbMax.  If the return value > nbMax, it means only part of the image
* was written, and the buffer needs to be bigger.
* If pBuffer is NULL, no data is written - the function just returns the required
* buffer size in bytes.
* A return value of <= 0 indicates an error, such as
*   The image is invalid (null or invalid DIB handle)
*   The format is unrecognized, not supported, not installed, etc.
*   You can't save that image in that format e.g. B&W image to JPEG format.
*   Insufficient memory for temporary data structures (or corrupted heap)
*   Other internal failure.
* You can call TWAIN_LastErrorCode and similar functions for more details.

DECLARE LONG DIB_WriteArrayToBuffer IN Eztwain3.dll ;
   STRING @ahdib, ;
   LONG n, ;
   LONG nFormat, ;
   STRING @pBuffer, ;
   LONG nbMax
* A combination of DIB_WriteArrayToFilename and DIB_WriteToBuffer.
* Writes n images to a memory buffer in the specified format.
* See DIB_WriteToBuffer above for the meaning of pBuffer and nbMax.
* Return value: See DIB_WriteToBuffer above.



DECLARE LONG DIB_ToDibSection IN Eztwain3.dll ;
   LONG hdib
* Converts the given DIB into a kind of bitmap called a DibSection.
* *** IMPORTANT: The input DIB is consumed and becomes invalid ***
* A DibSection is a special kind of HBITMAP.  Many languages
* and imaging classes (such as GDI+, .NET Image, Delphi TBitmap) do
* not easily accept DIBs but readily accept a DibSection/HBITMAP.

DECLARE LONG DIB_FromBitmap IN Eztwain3.dll ;
   LONG hbm, ;
   LONG hdc
* Create a DIB with the contents of a GDI bitmap (preferably a DibSection).
* >> The input bitmap is NOT deleted - the returned DIB is a copy.
* If hdc = 0 (NULL) a default HDC is used.
* See also: DIB_ToDibSection

DECLARE LONG DIB_IsBlank IN Eztwain3.dll ;
   LONG hdib, ;
   DOUBLE dDarkness
* Return TRUE(1) if the DIB has less than dDarkness fraction of 'dark' pixels.
* Return FALSE(0) otherwise.
* A typical value of dDarkness would be 0.02 which means 2% dark pixels.
* A page with less than 2% dark pixels is probably blank.

DECLARE DOUBLE DIB_Darkness IN Eztwain3.dll ;
   LONG hdibFull
* Returns the fraction of an image that consists of 'dark' pixels.
* These are pixels that would be black, if the image was converted
* to B&W using a smart thresholding.  See DIB_SmartThreshold.
* Used by DIB_IsBlank to decide if an image is blank.
* A return of 0.0 means none, 1.0 means all.  A typical office
* document is 0.02 (2%) to 0.32 (32%) dark pixels.

DECLARE DIB_GetHistogram IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nComponent, ;
   STRING @histo
* Count the number of occurences of each value of the specified component
* in the given DIB (see component codes below).  Put the counts
* of each value (0..255) into the histo array.
* The histo array *must* be an array of 256 32-bit integers.
* Only works on B&W, grayscale, palette, and 24-bit RGB images.
* Example: If hdib contains 237 pixels with a grayscale value of 17, then
* this call will return histo[17] = 237.  Components are normalized
* into the range 0..255.
* Note: If hdib is a 1-bit B&W image, then histo will be all 0's, except
* for hist[0] (black) and hist[255] (white).
*
* Component codes:
#DEFINE COMPONENT_GRAY 0
#DEFINE COMPONENT_RED 1
#DEFINE COMPONENT_GREEN 2
#DEFINE COMPONENT_BLUE 3
#DEFINE COMPONENT_LUMINANCE 0
#DEFINE COMPONENT_SAT 4
#DEFINE COMPONENT_HUE 5

* For gray and B&W images, R, G, and B components are equal, and Hue and Sat are 0.
* Other components available upon request: support@dosadi.com


DECLARE LONG DIB_ComponentCopy IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nComponent
* Extract and return one component (channel) of the given image.
* The returned image is an 8-bit grayscale image containing the
* specified channel of the input image, with the same width,
* height, and DPI.
* 
* Note: In future this function may return a 16-bit deep image
* when given a 16 bit/channel input image.

DECLARE DOUBLE DIB_Avg IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nComp
DECLARE DOUBLE DIB_AvgRegion IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nComp, ;
   LONG leftx, ;
   LONG topy, ;
   LONG w, ;
   LONG h
DECLARE DOUBLE DIB_AvgRow IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nComp, ;
   LONG rowy
DECLARE DOUBLE DIB_AvgColumn IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nComp, ;
   LONG colx
* Average the values of pixels in an image, region, row or column.
* Note that row 0 is the visually top-most row of an image.
* Averages either intensity (brightness) or individual color channels,
* or saturation.
* See component codes above, for DIB_GetHistogram.
* Regardless of image format, white = 255.0 and black = 0, even
* for 1-bit B&W or 16-bit grayscale or color images.
* DOES NOT SUPPORT: 4-bit/pixel images, CMY(K) images.

DECLARE LONG DIB_ProjectRows IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nComp
DECLARE LONG DIB_ProjectColumns IN Eztwain3.dll ;
   LONG hdib, ;
   LONG leftx, ;
   LONG topy, ;
   LONG w, ;
   LONG h, ;
   LONG nComp
* These functions create and return a 1 row x N column image, containing
* the average value of the rows (columns) of the input image, in the
* specified channel (component).
* If the source image is <= 8-bit/sample, the result image is 8-bit/sample.
* If the source image is 16 bit/sample, so is the result image.

DECLARE LONG DIB_Posterize IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nLevels


*--- EXPERIMENTAL: The following functions may be removed or changed at any time.
DECLARE LONG DIB_ForwardDCT IN Eztwain3.dll ;
   LONG hdib

*--- OBSOLETE: The following functions are for backward compatibility only:
DECLARE LONG TWAIN_WriteNativeToFilename IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
DECLARE LONG TWAIN_LoadNativeFromFilename IN Eztwain3.dll ;
   STRING sFileName
*HDIB EZTAPI TWAIN_LoadNativeFromFile(HFILE fh);
* removed - contact Dosadi if this causes problems for you.
DECLARE LONG TWAIN_NegotiateXferCount IN Eztwain3.dll ;
   LONG nXfers
DECLARE LONG TWAIN_DibDepth IN Eztwain3.dll ;
   LONG hdib
DECLARE LONG TWAIN_DibWidth IN Eztwain3.dll ;
   LONG hdib
DECLARE LONG TWAIN_DibHeight IN Eztwain3.dll ;
   LONG hdib
DECLARE LONG TWAIN_DibNumColors IN Eztwain3.dll ;
   LONG hdib
DECLARE LONG TWAIN_DibRowBytes IN Eztwain3.dll ;
   LONG hdib
DECLARE TWAIN_DibReadRow IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nRow, ;
   STRING @prow
DECLARE LONG TWAIN_CreateDibPalette IN Eztwain3.dll ;
   LONG hdib
DECLARE TWAIN_DrawDibToDC IN Eztwain3.dll ;
   LONG hDC, ;
   LONG dx, ;
   LONG dy, ;
   LONG w, ;
   LONG h, ;
   LONG hdib, ;
   LONG sx, ;
   LONG sy

*--------- File Read/Write

*---- Dosadi File Format Codes
#DEFINE EZT_FF_TIFF 0
#DEFINE EZT_FF_BMP 2
#DEFINE EZT_FF_JFIF 4
#DEFINE EZT_FF_PNG 7
#DEFINE EZT_FF_PDFA 15
#DEFINE EZT_FF_DCX 97
#DEFINE EZT_FF_GIF 98
#DEFINE EZT_FF_PDF 99

* GIF and DCX support is only provided by EZTwain.
* Note: BMP support is built into EZTwain, so is always available.

DECLARE LONG TWAIN_IsJpegAvailable IN Eztwain3.dll
* Return TRUE (1) if JPEG/JFIF image files can be read and written.
* Returns 0 if JPEG support has not been installed.

DECLARE LONG TWAIN_IsPngAvailable IN Eztwain3.dll
* Return TRUE (1) if PNG format support is available.

DECLARE LONG TWAIN_IsTiffAvailable IN Eztwain3.dll
* Return TRUE (1) if TIFF format support is available.

DECLARE LONG TWAIN_IsPdfAvailable IN Eztwain3.dll
* Return TRUE (1) if PDF format support is available.

DECLARE LONG TWAIN_IsGifAvailable IN Eztwain3.dll
* Return TRUE (1) if GIF format support is available.

DECLARE LONG TWAIN_IsDcxAvailable IN Eztwain3.dll
* Return TRUE (1) if DCX format support is available.
* Note that DCX files can only hold 1-bit
* B&W images - EZTwain converts the image data as needed.

DECLARE LONG TWAIN_IsFormatAvailable IN Eztwain3.dll ;
   LONG nFF
* Return TRUE (1) if the specified file format support
* is available for writing and possibly reading files.
* A format is considered available if EZTwain can load
* the necessary DLLs.  See the 

DECLARE LONG TWAIN_FormatVersion IN Eztwain3.dll ;
   LONG nFF
* Return the format module version * 100.

DECLARE LONG TWAIN_IsFileExtensionAvailable IN Eztwain3.dll ;
   STRING sExt
* Return TRUE (1) if the file format corresponding to the given
* file extension ("TIF", ".gif", "jpeg", etc.) is available.
* Case does not matter, leading '.' is optional.

DECLARE LONG TWAIN_FormatFromExtension IN Eztwain3.dll ;
   STRING sExt, ;
   LONG nFF
* Return the file-format code (see File Formats above) for
* the given extension.  If pzExt is unrecognized, returns nFF.
* Case does not matter, leading '.' is optional.

DECLARE STRING TWAIN_ExtensionFromFormat IN Eztwain3.dll ;
   LONG nFF, ;
   STRING sDefExt
* Return the default extension associated with a file format.(See File Formats above.)
* Note: The leading '.' is included e.g. ".bmp", ".tif", etc.
* If nFF is not a valid value, returns its second parameter.

DECLARE TWAIN_GetExtensionFromFormat IN Eztwain3.dll ;
   LONG nFF, ;
   STRING sDefExt, ;
   STRING @szExtension
* Return the default extension for the given file-format code, in the 3rd parameter.
* The caller is responsible for allocating a string of at least 5 characters for the 3rd parameter.
* If the file format is not recognized, returns the value of the 2nd parameter.

DECLARE LONG TWAIN_SetSaveFormat IN Eztwain3.dll ;
   LONG nFF
DECLARE LONG TWAIN_GetSaveFormat IN Eztwain3.dll
* Select the default file format for DIB_WriteToFilename
* and TWAIN_WriteToFilename to use, when they do not
* recognize the file extension.
* Displays a warning message if the format is not available.
* Returns TRUE (1) if ok, FALSE (0) if format is invalid or not available.
* See list of file formats above.  Some formats are not supported
* by some versions of EZTWAIN, or require external DLLs be installed.

DECLARE TWAIN_SetJpegQuality IN Eztwain3.dll ;
   LONG nQ
DECLARE LONG TWAIN_GetJpegQuality IN Eztwain3.dll
* Set the 'quality' of subsequently saved JPEG/JFIF image files.
* nQ = 100 is maximum quality & minimum compression.
* nQ = 75 is 'good' quality, the default.
* nQ = 1 is minimum quality & maximum compression.

*- Special TIFF options ------------------------------------------

DECLARE TWAIN_SetTiffStripSize IN Eztwain3.dll ;
   LONG nBytes
DECLARE LONG TWAIN_GetTiffStripSize IN Eztwain3.dll
* Set/Get the size of the 'strips' that TIFF files are divided into.
* Some (bogus) TIFF readers cannot handle multiple strips, to make
* them happy set the strip size to -1.
* Default value = 32768 (subject to change, in theory.)

DECLARE LONG TWAIN_SetTiffImageDescription IN Eztwain3.dll ;
   STRING sText
DECLARE LONG TWAIN_SetTiffDocumentName IN Eztwain3.dll ;
   STRING sText
* Set the TIFF ImageDescription or DocumentName tags for output.
* These values apply only to the next TIFF file written, and are cleared
* once the file is closed.

DECLARE LONG TWAIN_SetTiffCompression IN Eztwain3.dll ;
   LONG nPT, ;
   LONG nComp
DECLARE LONG TWAIN_GetTiffCompression IN Eztwain3.dll ;
   LONG nPT
* Set/Get the compression mode to use when writing TIFF files.
* Set returns TRUE (1) if successful, FALSE (0) otherwise.
* nPT specifies the Pixel Type - See the TWPT_* constants.
* Different compressions apply to different pixel types - see below.
* Using nPT=-1 means 'for all applicable pixel types.'
* nComp specifies the compression, here are the codes:
#DEFINE TIFF_COMP_NONE 1
#DEFINE TIFF_COMP_CCITTRLE 2
#DEFINE TIFF_COMP_CCITTFAX3 3
#DEFINE TIFF_COMP_CCITTFAX4 4
#DEFINE TIFF_COMP_LZW 5
#DEFINE TIFF_COMP_JPEG 7
#DEFINE TIFF_COMP_PACKBITS 32773

* Default for BW is TIFF_COMP_CCITTFAX4
* Default for all other pixel types is TIFF_COMP_NONE.

* Setting TIFF tags explicitly, including custom/private tags:
DECLARE LONG TWAIN_SetTiffTagShort IN Eztwain3.dll ;
   LONG nTagId, ;
   INTEGER sValue
DECLARE LONG TWAIN_SetTiffTagLong IN Eztwain3.dll ;
   LONG nTagId, ;
   LONG nValue
DECLARE LONG TWAIN_SetTiffTagString IN Eztwain3.dll ;
   LONG nTagId, ;
   STRING sText
DECLARE LONG TWAIN_SetTiffTagDouble IN Eztwain3.dll ;
   LONG nTagId, ;
   DOUBLE dValue
DECLARE LONG TWAIN_SetTiffTagRational IN Eztwain3.dll ;
   LONG nTagId, ;
   DOUBLE dValue
DECLARE LONG TWAIN_SetTiffTagRationalArray IN Eztwain3.dll ;
   LONG nTagId, ;
   STRING @dValues, ;
   LONG n
DECLARE LONG TWAIN_SetTiffTagBytes IN Eztwain3.dll ;
   LONG nTagId, ;
   STRING pdata, ;
   LONG nBytes
DECLARE LONG TWAIN_SetTiffTagUndefined IN Eztwain3.dll ;
   LONG nTagId, ;
   STRING pdata, ;
   LONG nBytes
* Note: It works to use SetTiffTagDouble to set standard TIFF tags that are of
* type RATIONAL, but we recommend using SetTiffTagRational.
* If you have trouble setting a custom private tag, it may help to
* define it to EZTwain - see TWAIN_DefineCustomTiffTag, below.

DECLARE TWAIN_ResetTiffTags IN Eztwain3.dll
* The functions above allow specific TIFF tags to be set.
* Whatever value(s) you set will be used in *each image written to TIFF*
* until you call TWAIN_ResetTiffTags.
* Note that integer values are appropriately converted to 16- or 32-bit
* signed or unsigned as needed by the specific tag.

DECLARE LONG TWAIN_GetTiffTagAscii IN Eztwain3.dll ;
   STRING sFilename, ;
   LONG nPage, ;
   LONG nTag, ;
   LONG nLen, ;
   STRING @buffer
* Read the value of the specified tag from the given page of the given TIFF file,
* copying the string into buffer, which has room for len characters.
* Returns True(1) if successful, False(0) otherwise.

DECLARE STRING TWAIN_TiffTagAscii IN Eztwain3.dll ;
   STRING sFilename, ;
   LONG nPage, ;
   LONG nTag
* Return the value of the specified tag from the given page of the given TIFF file,
* as a human-readable string.
* Numeric values are converted to decimal numeric representation.
* In case of failure, it returns the empty string.
* In case of error, call TWAIN_ReportLastError to display details,
* or call TWAIN_LastErrorCode and related functions.

DECLARE TWAIN_SetFileAppendFlag IN Eztwain3.dll ;
   LONG bAppend
DECLARE LONG TWAIN_GetFileAppendFlag IN Eztwain3.dll
* Set or get the File Append Flag.
* When this flag is non-zero and EZTwain writes to an existing TIFF, PDF or DCX
* file, the new images are *appended* to the existing file.
* When this flag is False (0), writing to any existing file replaces the file.
*
* The default state of this flag is: False (0).
*
* Note: Only TIFF, PDF, and DCX formats are affected.
* This applies to all functions that write images, primarily:
*  TWAIN_AcquireToFilename, TWAIN_AcquireMultipageFile,
*  DIB_WriteToFilename, TWAIN_BeginMultipageFile, etc.

*- PDF Specific ------------------------------------------


DECLARE LONG PDF_IsOneOfOurs IN Eztwain3.dll ;
   STRING sFileName
* Returns TRUE(1) if the specified PDF file was probably written by the
* Dosadi PDF module.

* These functions configure or add information to the next output PDF file:
DECLARE LONG TWAIN_SetPdfTitle IN Eztwain3.dll ;
   STRING sText
DECLARE LONG TWAIN_SetPdfAuthor IN Eztwain3.dll ;
   STRING sText
DECLARE LONG TWAIN_SetPdfSubject IN Eztwain3.dll ;
   STRING sText
DECLARE LONG TWAIN_SetPdfKeywords IN Eztwain3.dll ;
   STRING sText
DECLARE LONG TWAIN_SetPdfCreator IN Eztwain3.dll ;
   STRING sText

* Writing metadata into PDF:
DECLARE LONG PDF_SetTitle IN Eztwain3.dll ;
   STRING sText
DECLARE LONG PDF_SetAuthor IN Eztwain3.dll ;
   STRING sText
DECLARE LONG PDF_SetSubject IN Eztwain3.dll ;
   STRING sText
DECLARE LONG PDF_SetKeywords IN Eztwain3.dll ;
   STRING sText
DECLARE LONG PDF_SetCreator IN Eztwain3.dll ;
   STRING sText

DECLARE LONG PDF_SetCompression IN Eztwain3.dll ;
   LONG nPT, ;
   LONG nComp
DECLARE LONG PDF_GetCompression IN Eztwain3.dll ;
   LONG nPT
* Select the compression algorithm to use for images with the given pixel format.
* See the TWPT_* constants for the various pixel formats.
* Note that a pixel format of -1 means 'all applicable formats'.
* Available values of nComp are:
#DEFINE COMPRESSION_DEFAULT -1
#DEFINE COMPRESSION_NONE 1
#DEFINE COMPRESSION_FLATE 5
#DEFINE COMPRESSION_JPEG 7

DECLARE LONG PDF_SelectPageSize IN Eztwain3.dll ;
   LONG nPaper
DECLARE LONG PDF_SelectedPageSize IN Eztwain3.dll
* Set/Get the standard page-size for subsequent PDF output pages.
* The values are PAPER_ values defined elsewhere
* in this file, search for PAPER_A4 etc.
* EZTwain initializes this to PAPER_NONE (0).
* With PAPER_NONE selected, EZTwain writes each output image into a
* page the same size as the image.  Setting a page size tells
* EZTwain to center each output image within a page of the
* specified size, shrinking larger images to fit.
* Calling PDF_SelectPageSize(PAPER_NONE) clears the page-size
* back to the default i.e. 'no specific size'.

DECLARE LONG PDF_SetPDFACompliance IN Eztwain3.dll ;
   LONG nLevel
DECLARE LONG PDF_GetPDFACompliance IN Eztwain3.dll
* Set/Get the PDF/A Compliance level.
* Level 0 is 'no particular compliance'. (*default*)
* Level 1 is PDF/A-1(b) - the PDF/A Part 1 level suitable for
* scanned documents.
* No other nLevel values are accepted at this time.
* When PDFA compliance is set to 1, PDF output is made to comply with
* ISO 19005-1 PDF/A-1.  For the most part this is invisible, but certain
* PDF settings and operations become illegal, and there are optional
* function calls that make your PDF's "more" PDF/A compliant.


*-- Passwords and encryption of PDF files ------------------------
*

DECLARE LONG PDF_IsEncrypted IN Eztwain3.dll ;
   STRING sFileName
* Returns TRUE(1) if the specified PDF file is encrypted.

DECLARE PDF_SetOpenPassword IN Eztwain3.dll ;
   STRING sPassword
* Set the password to be used to open subsequent PDF files.
* This password is used until reset to the empty string.
*
* Once you set a non-null OpenPassword, the user will not be prompted
* for a password when an encrypted PDF is opened for reading:
* If the OpenPassword is valid for the file, the file will be
* silently opened and decrypted.
* If the OpenPassword is not valid for the file, the function that
* is trying to read the file will fail. In this case,
* the code returned by TWAIN_LastErrorCode is EZTEC_PDF_PASSWORD

* To suppress PDF password prompting by EZTwain, set the OpenPassword
* to some extremely unlikely password string, such as " " or "1".

DECLARE PDF_SetUserPassword IN Eztwain3.dll ;
   STRING sPassword
* Define a user password for the next/current output PDF file.
* This turns on encryption for the file.
* When a PDF file is completed and closed, this user password is cleared.

DECLARE PDF_SetOwnerPassword IN Eztwain3.dll ;
   STRING sPassword
* Define an owner password for the next/current output PDF file.
* This turns on encryption for the file.
* When a PDF file is completed and closed, this owner password is cleared.

DECLARE PDF_SetPermissions IN Eztwain3.dll ;
   LONG nPermission
DECLARE LONG PDF_GetPermissions IN Eztwain3.dll
* Set or Get the permissions mask to be written into the next/current
* output PDF file. This mask specifies operations to be allowed or
* prevented on the file - see the PDF_PERMIT constants.
*
* Important Notes
*
* * Permissions are only written if you set a User or Owner password.
* * Acrobat honors these restrictions, but other PDF readers may not.
* * Any permissions you set only apply to the next PDF file you write.
* * The default permissions mask is 'allow everything' (-1)
* * Setting permissions=0 means 'prevent everything'
*
* You can use bitwise operations, or +/- to combine these constants.
* For example, to disallow copying text and graphics from the file:
*    PDF_SetPermissions(PDF_PERMIT_ALL - PDF_PERMIT_COPY)
*
*      named constant                                                                                 value                             if restricted, Acrobat will prevent:
#DEFINE PDF_PERMIT_PRINT 4
#DEFINE PDF_PERMIT_MODIFY 8
#DEFINE PDF_PERMIT_COPY 16
#DEFINE PDF_PERMIT_ANNOTS 32
* You can also use this nPermission value, by itself:
#DEFINE PDF_PERMIT_ALL -1


*-- Writing text into PDF. ------------------------
*
* The following functions apply to the next PDF file or page that is output,
* so you make them *before* you write the PDF page they apply to.

DECLARE PDF_DrawText IN Eztwain3.dll ;
   DOUBLE leftx, ;
   DOUBLE topy, ;
   STRING sText
* Draw text into the next PDF page, x pixels from the left edge
* and y pixels down from the top of the page.
* Note 1: This is not 'native' PDF coordinates, which are
* usually in points, from the lower-left corner of the page.
* Note 2: This call only makes sense if followed at some point
* by a call that writes an image to PDF.

DECLARE PDF_DrawInvisibleText IN Eztwain3.dll ;
   DOUBLE leftx, ;
   DOUBLE topy, ;
   STRING sText
* Like PDF_DrawText, but text is drawn in invisible mode.

DECLARE PDF_SetTextVisible IN Eztwain3.dll ;
   LONG bVisible
DECLARE LONG PDF_GetTextVisible IN Eztwain3.dll
* Set the visibility of the text written by subsequent PDF_DrawText
* calls. A parameter of True (non-0) means make text visible, a parameter
* of False (0) means make text invisible.

DECLARE PDF_SetTextSize IN Eztwain3.dll ;
   DOUBLE dfs
* Set the size of the current font, for subsequent PDF_DrawText calls.
* Normally this is a traditional size in points, like 10.
DECLARE PDF_SetTextHorizontalScaling IN Eztwain3.dll ;
   DOUBLE dhs

DECLARE LONG PDF_WriteOcrText IN Eztwain3.dll ;
   STRING text, ;
   STRING @ax, ;
   STRING @ay, ;
   STRING @aw, ;
   STRING @ah, ;
   DOUBLE xdpi, ;
   DOUBLE ydpi
* Write previously OCR'd text to the next PDF output page.
* ---parameters---
* text is the text, of course - as returned by OCR_Text.
* ax and ay are arrays of x,y positions of the characters in text - as returned
* by OCR_GetCharPositions.  These are pixel coordinates relative to the top-left of the page.
* aw and ah are arrays of (width,height) information as returned by OCR_GetCharSizes.
* xdpi and ydpi are the resolution values (DPI) of the source image, required to map the text
* size from pixels into PDF font sizes.  The resolution can be obtained from the image
* using DIB_XResolution and DIB_YResolution, or you can call OCR_GetResolution at the
* same time you call OCR_GetCharPositions and OCR_GetCharSizes.

*---------------------------------------------------------

DECLARE LONG TWAIN_WriteToFilename IN Eztwain3.dll ;
   LONG hdib, ;
   STRING sFileName
* Writes the specified image to a file.
* This is the same as DIB_WriteToFilename - please refer to that function.

DECLARE LONG TWAIN_LoadFromFilename IN Eztwain3.dll ;
   STRING sFileName
* Load a .BMP file, or any other available format.
* Accepts a filename (including path & extension).
* If the filename is NULL or points to a null string, the user is
* prompted to choose a file with a standard File Open dialog.
* Returns a DIB handle if successful, otherwise NULL.

DECLARE LONG TWAIN_LoadPage IN Eztwain3.dll ;
   STRING sFileName, ;
   LONG nPage
* Short for DIB_SelectPageToLoad, DIB_LoadFromFilename.
* Load the specified page from the specified file.
* Page 0 is the first page in a file.  Multiple
* pages are only supported in TIFF, PDF and DCX files, all other file
* formats have a single page, page #0.

DECLARE LONG TWAIN_FormatOfFile IN Eztwain3.dll ;
   STRING sFileName
* Return the format of the specified file.
* See the EZT_FORMAT_ codes elsewhere in this file.
* A return value < 0 means 'unrecognized format'.

DECLARE LONG TWAIN_PagesInFile IN Eztwain3.dll ;
   STRING sFileName
* Return the number of pages in the specified file.
* For multipage formats (TIFF, PDF, DCX), the pages are counted.
* All other recognized formats return a page count of 1.
* If the file cannot be opened, read, recognized, etc.
* this function records an error and returns -1.

DECLARE LONG TWAIN_PromptForOpenFilename IN Eztwain3.dll ;
   STRING @sFileName
* Prompt the user for a file to open.
* Returns TRUE(1) if user selected a file, FALSE(0) if user cancelled.
* If it returns TRUE, the fully-qualified filepath & name is returned
* in the buffer referenced by the parameter.
* The caller is responsible for allocating (and deallocating) the
* buffer of at least 260 characters.
* The file dialog has a file-type list, which is loaded based
* on the formats that are currently supported for loading.
* The default file-type is "any supported format".

*--------- File View Dialog

DECLARE LONG TWAIN_ViewFile IN Eztwain3.dll ;
   STRING sFileName
* Display the specified file in a viewer window that allows the
* user to browse to all pages (if more than one).
* If the file name is NULL or the null string, the user is prompted
* with a standard file-open dialog, offering all the filetypes that
* EZTwain believes it can open.
* The default dialog has an OK button only.
* Return values:
*  1   [OK] button pressed (in modal dialog)
*  1   File displayed - in case of modeless dialog.
*  0   [Cancel] button pressed
* -1   user cancelled file-open prompt (if you supplied a null filename)
* -2   error displaying dialog, opening file, etc.

DECLARE LONG TWAIN_SetViewOption IN Eztwain3.dll ;
   STRING sOption, ;
   STRING sValue
* Set various options and parameters for the viewer window.
* See TWAIN_ViewFile above.
*
* option                                                                                              form                              meaning
* title                                                                                               string                            the title (caption) of the viewer window
* left                                                                                                                                  x|x%                              left(x) coordinate of window, in pixels or as a percent of screen.
* top                                                                                                                                   y|y%                              top coordinate of window
* bottom                                                                                              y|y%
* right                                                                                               x|x%
* width                                                                                               w|w%                              width of viewer window, in pixels or as a percent of screen.
* height                                                                                              h|h%
* size                                                                                                                                  w,h                                                                 width and height together, pixels or percentages
* topleft                                                                                             x,y                                                                 x and y together, pixels or percentages
* position                                                                                            x,y,w,h                           left,top,width,height - in pixels or percentages
* pos                                                                                                                                                                     same as position
* pos.remember                                                      bool                              if true, remember viewer position between showings. Default: false.
* timeout                                                                                             n                                                                   in seconds. Currently ignored.
* visible                                                                                             bool                              if viewer is open, show or hide it.  Default: true
* ok.visible                                                        bool                              if true, include an [OK] button in the viewer. Default: true.
* cancel.visible                  bool                              if true, include a [Cancel] button. Default: false
* print.visible                   bool                              if true, include a [Print] button. Default: false.
* modeless                                                                                            bool                              if true, leave viewer open until TWAIN_ViewClose. Default: false.
* modal                                                                                               bool                              opposite of modeless.
* reset                                                                                               ...                                                                 setting this option resets all options to default value.


DECLARE LONG TWAIN_IsViewOpen IN Eztwain3.dll
* Return True if the viewer window is open, False otherwise.

DECLARE LONG TWAIN_ViewClose IN Eztwain3.dll
* If the viewer window is open (as a modeless dialog), close it.
* The viewer window is normally modal, but can be made modeless
* with TWAIN_SetViewOption("modeless", "true")
* No effect if no viewer window is open.
* Returns True(1) if it closed the viewer window, False(0) otherwise.

DECLARE LONG TWAIN_GetLastViewPosition IN Eztwain3.dll ;
   LONG @pleft, ;
   LONG @ptop, ;
   LONG @pwidth, ;
   LONG @pheight
* Return the screen coordinates, in pixels, of the last known position of the
* viewer window (the dialog displayed by TWAIN_ViewFile and DIB_View functions.)
* The four parameters are pointers to 32-bit integers or if your language
* prefers, four 32-bit integers passed by reference.
* The four returned values are the left edge, the top edge (counting down from screen top)
* the width, and the height of the View window, the last time it was closed or resized.
*
* This function can be used in conjunction with TWAIN_SetViewOption("position","x,y,w,h") to
* remember and restore the view window position.

*--------- Multipage File Output

#DEFINE MULTIPAGE_TIFF 0
#DEFINE MULTIPAGE_PDF 1
#DEFINE MULTIPAGE_DCX 2

DECLARE LONG TWAIN_SetMultipageFormat IN Eztwain3.dll ;
   LONG nFF
DECLARE LONG TWAIN_GetMultipageFormat IN Eztwain3.dll
* Select/query the default multipage file save format.
* The default when EZTwain is loaded is MULTIPAGE_TIFF.
* Note that if you use a recognized extension in the name
* of your multipage file - such as .tif, .pdf or .dcx, then
* the file will be written in that format.  The file
* extension overrides SetMultipageFormat.
*
* SetMultipageFormat returns:
*  0 = success,
* -1 = invalid/unrecognized format
* -3 = format is currently unavailable (missing/bad DLL)

DECLARE TWAIN_SetLazyWriting IN Eztwain3.dll ;
   LONG bYes
DECLARE LONG TWAIN_GetLazyWriting IN Eztwain3.dll
* Get/Query the value of the 'LazyWriting' flag.
* NOTE: The default value of this flag is: TRUE.
* When the LazyWriting flag is set (TRUE), multipage files
* are written by a background thread, allowing your
* program to continue executing (scanning for example).
* Only when EndMultipageFile is called does the program
* wait until all the pages of the file have actually
* been written to disk.
* This also applies to AcquireMultipageFile, which internally
* uses these multipage output functions.

DECLARE LONG DIB_WriteArrayToFilename IN Eztwain3.dll ;
   STRING @ahdib, ;
   LONG n, ;
   STRING sFileName
* Write n images from array ahdib to the specified file.
* If n is 1, this is exactly equivalent to calling DIB_WriteToFilename.
* If n > 1, this is a shortcut for calling
*    TWAIN_BeginMultipageFile,
*      TWAIN_DibWritePage (for each image)
*    TWAIN_EndMultipageFile
* ...with appropriate error handling, of course.
*
* Return values:
*                                  0                                success
*                                 -1                                user cancelled File Save dialog
*                                 -2                                file open error (invalid path or name, or access denied)
*                                 -3                                a) image is invalid (null or invalid DIB handle)
*      b) support for the save format is not available
*      c) DIB format incompatible with save format e.g. B&W to JPEG.
*                                 -4                                writing data failed, possibly output device is full
*  -5  other unspecified internal error
*  -6  a multipage file is already open
*  -7  multipage support is not installed.

DECLARE LONG TWAIN_BeginMultipageFile IN Eztwain3.dll ;
   STRING sFileName
* Create an empty multipage file of the given name.
* If the filename is NULL or points to the null string, the user
* is prompted with a standard File Save dialog.
* If the filename includes an extension (.tif, .tiff, .mpt, .pdf or .dcx)
* then the corresponding format is used for the file.
* If you do not supply an extension, the default multipage format is used.

* Return values:
*                                  0                                success
*                                 -1                                user cancelled File Save dialog
*                                 -2                                file open error (invalid path or name, or access denied)
*  -3  file format not available
*  -5  other unspecified internal error
*  -6  multipage file already open
*  -7  Multipage support is not installed.

DECLARE LONG TWAIN_DibWritePage IN Eztwain3.dll ;
   LONG hdib
*   0                             success
*  -2  internal limit exceeded or insufficient memory
*  -3  File format is not available (EZxxx DLL not found)
*  -4  Write error: Output device is full?
*  -5  invalid/unrecognized file format or 'other' - internal
*  -6  multipage file not open
*  -7  Multipage support is not installed.

DECLARE LONG TWAIN_EndMultipageFile IN Eztwain3.dll
*   0                             success
*  -3  File format is not available
*  -4  Write error - drive offline, or ?? (very unlikely)
*  -5  invalid/unrecognized file format or other internal error
*  -6  multipage file not open
*  -7  Multipage support is not installed.

DECLARE LONG TWAIN_MultipageCount IN Eztwain3.dll
* Return the number of images (scans) written to the most recently
* started multipage file.  In other words, this returns a counter
* which is reset by BeginMultipageFile, and is incremented by DibWritePage.

DECLARE LONG TWAIN_IsMultipageFileOpen IN Eztwain3.dll
* Return True if a multipage output file is open, False otherwise.
* Only one multipage output file can be open at a time (per process.)


DECLARE STRING TWAIN_LastOutputFile IN Eztwain3.dll
* Return the name of the last file written by EZTwain.
* Useful if you pass NULL or the empty string as a filename to
* DIB_WriteToFilename or TWAIN_AcquireToFilename, etc.


DECLARE TWAIN_SetOutputPageCount IN Eztwain3.dll ;
   LONG nPages
* Tell EZTwain how many pages you are about to write to a file.
* This is OPTIONAL: The only effect is to add PageNumber tags
* to TIFF files.  You can use nPages=0, which means "I don't know".

DECLARE LONG TWAIN_FileCopy IN Eztwain3.dll ;
   STRING sInFile, ;
   STRING sOutFile, ;
   LONG nOptions
* Read all the images or pages from the in file and write them to the out file.
* nOptions is currently not used and should be 0.
* The formats need not be the same, in fact this function is most often
* used to convert for example from TIFF to PDF.  If you specify a single-image
* output format (BMP, GIF, PNG, JPG) the input file must have only one page.
* Return values:
*                                  0                                success
*                                 -1                                user cancelled
*                                 -2                                file open error (invalid path or name, or access denied)
*  -3  file format not available or inappropriate (e.g. copying 5-page TIF to JPEG)
*  -5  other unspecified internal error
*  -7  Multipage support is not installed.

*--------- Network file transfer services
*
* These functions require EZCurl.dll to be
* in the same folder as Eztwain3.dll

DECLARE LONG UPLOAD_IsAvailable IN Eztwain3.dll
* TRUE(1) if uploading services are available (= EZCurl.dll can be loaded.)
* Returns FALSE(0) otherwise.

DECLARE LONG UPLOAD_Version IN Eztwain3.dll
* Return the upload module version * 100.

DECLARE LONG UPLOAD_MaxFiles IN Eztwain3.dll
* Return the maximum number of files that can be uploaded in one UPLOAD operation.
* i.e. UPLOAD_FilesToURL, UPLOAD_DibsSeparatelyToURL.

DECLARE LONG UPLOAD_AddFormField IN Eztwain3.dll ;
   STRING fieldName, ;
   STRING fieldValue
* Set a form field to a value in the next Upload (see below).
* The name of the field must be expected by the page/script you upload to.
* All fields set with this function are discarded and forgotten after
* the next upload that uses them.
*
* For example, suppose you have been uploading scanned documents to your server
* using a web form like this:
* <form name="form1" method="post" action="http://server.com/newdoc.php" >
* <input type="hidden" name="key" value="12345678">
* <input type="text" name="vendor id">
* <input type="file" name="file">
* <input type="submit" name="submit" value="Submit">
* </form>
*
* You might automate the upload of a just-scanned image in memory (hdib)
* with vendor id = 1290331, with code similar to this:
*    UPLOAD_AddFormField("key", "12345678")
*    UPLOAD_AddFormField("vendor id", "1290331")
*    UPLOAD_DibToURL(hdib, "http://server.com/newdoc.php", "document.pdf", "file")

DECLARE LONG UPLOAD_AddHeader IN Eztwain3.dll ;
   STRING header
* Add a header line to the next HTTP upload.
* You should have some understanding of HTTP protocol to use this!
* Don't include any line-break characters.
* To send a cookie, use UPLOAD_AddCookie (below).

DECLARE LONG UPLOAD_AddCookie IN Eztwain3.dll ;
   STRING cookie
* Add a cookie line to the next HTTP upload.
* Often used to provide session id's e.g.
*    UPLOAD_AddCookie("ASP.NET_SessionID=" & strSessionID)
* or
*    UPLOAD_AddCookie("JSESSIONID=" & strSessionID)

DECLARE UPLOAD_EnableProgressBar IN Eztwain3.dll ;
   LONG bEnable
DECLARE LONG UPLOAD_IsEnabledProgressBar IN Eztwain3.dll
* Enable or disable the progress-bar during uploads.
* Default state is enabled (TRUE).

DECLARE LONG UPLOAD_DibToURL IN Eztwain3.dll ;
   LONG hdib, ;
   STRING URL, ;
   STRING fileName, ;
   STRING fieldName
DECLARE LONG UPLOAD_DibsToURL IN Eztwain3.dll ;
   STRING @ahdib, ;
   LONG n, ;
   STRING URL, ;
   STRING fileName, ;
   STRING fieldName
DECLARE LONG UPLOAD_DibsSeparatelyToURL IN Eztwain3.dll ;
   STRING @ahdib, ;
   LONG n, ;
   STRING URL, ;
   STRING fileName, ;
   STRING fieldName
DECLARE LONG UPLOAD_FilesToURL IN Eztwain3.dll ;
   STRING files, ;
   STRING URL, ;
   STRING fieldName
* Upload an image, set of images, or some files on disk, to a script on a server,
* AS IF a form was being submitted via HTTP-POST, with a field or fields of type 'file'.
*
* Important Note - This confuses some people, don't let it happen to you!
* Only UPLOAD_FilesToURL looks for actual disk files and uploads them.
* All the other UPLOAD functions upload image data, *pretending* it is from a file - no such
* file is read, used, or created on the client machine.
*
* UPLOAD_DibsSeparatelyToURL uploads each image as a separate file, appending '1', '2', etc.
* to both the filename and the fieldname.  So if you upload n images with fileName="page.jpg"
* and fieldName="file", it will upload files as "file1"="page1.jpg", "file2=page2.jpg", etc.
*
* Similarly, UPLOAD_FilesToURL uploads multiple files, appending the counter to the fieldName.
* If you specify a fieldName of "file", UPLOAD_FilesToURL will use "file1", "file2", etc.
* Note that this applies even if you upload just one file.
*
* hdib      = handle to image to upload.
* ahdib     = address or reference to array of hdibs (image handles).
* n         = number of images in array ahdib.
* fileName  = name of (imaginary) file being uploaded.
*             Note: the extension on the filename determines the file format.
* files     = a string containing one or more filenames, separated by semicolons (;) or vertical bars (|)
* URL       = URL to POST the file to, such as http://www.dosadi.com/upload.php
* fieldName = name of the form-field. If null or blank, "file" is used.
*
* NOTE: When uploading multiple images as a single file, you must of course
* use a file format that supports multiple pages: TIFF, PDF, or DCX.
*
* Return values:
*    0    success (transaction completed)
*         Important: A success return (0) means only that the data was sent to the
*         server and a response was received, not that the receiving script
*         necessarily accepted the submitted file.  See DIB_UploadResponse below. 
*   -1                               user cancelled File Save dialog (should never happen)
*   -2                               could not write temp file - access denied, volume protected, etc.
*   -3    a) image is invalid (null or invalid DIB handle)
*         b) The DLL(s) needed to save that format failed to load
*         c) DIB format incompatible with save format e.g. uploading a B&W image as JPEG.
*         d) fileName does not have a recognized extension (.tif, .jpg, .gif, etc)
*   -4    writing data failed, maybe the disk with the temp folder is full?
*   -5    other unspecified internal error
* -100+n  libcurl returned error code n
*         for example:
* -106    could not resolve host
* -107    couldn't connect
* -126    could not open/read local file

DECLARE UPLOAD_SetProxy IN Eztwain3.dll ;
   STRING hostport, ;
   STRING userpwd, ;
   LONG bTunnel

DECLARE STRING UPLOAD_Response IN Eztwain3.dll
* Return the text received from the server in response to the last upload.
* You can check this text to see if the server-script accepted the upload.
* There is no predefined limit to the length of the returned string - please
* code defensively.  This call is extremely fast, 
* (See DIB_PostToURL above.)

DECLARE LONG UPLOAD_ResponseLength IN Eztwain3.dll
* Return the length of the last server response string, as returned
* by UPLOAD_Response.

DECLARE UPLOAD_GetResponse IN Eztwain3.dll ;
   STRING @ResponseText
* Retrieve the text received from the server in response to the last upload.
* * This text is limited to 1024 characters. *
* (See DIB_PostToURL above.)

DECLARE UPLOAD_ClearResponse IN Eztwain3.dll

* Upload callback support

*--------- Application Registration and Licensing

DECLARE TWAIN_SetAppTitle IN Eztwain3.dll ;
   STRING sAppTitle
* The short form of Application/Product name registration.
* Sets the product name as far as EZTwain and TWAIN are concerned.
* This title is used in several ways:
* As the title (caption) of any EZTwain dialog boxes / error boxes.
* In the progress box of some devices as they transfer images.
* In the 'software' field of saved image files in some formats,
* including TIFF.

DECLARE TWAIN_SetApplicationKey IN Eztwain3.dll ;
   LONG nKey
* Unlock EZTwain Pro for use with the current application - call this AFTER
* calling RegisterApp or SetAppTitle above:  The nKey value must match
* the application title (product name) passed to one of those functions.

DECLARE TWAIN_ApplicationLicense IN Eztwain3.dll ;
   STRING sAppTitle, ;
   LONG nAppKey
* Unlock EZTwain using a Single Application License.

DECLARE TWAIN_SetVendorKey IN Eztwain3.dll ;
   STRING sVendorName, ;
   LONG nKey
* Unlock EZTwain using a Universal Application / Vendor License

DECLARE TWAIN_OrganizationLicense IN Eztwain3.dll ;
   STRING sOrganization, ;
   LONG nKey
* Unlock EZTwain using an Organization / In-House Application License.

DECLARE LONG TWAIN_RenewTrialLicense IN Eztwain3.dll ;
   LONG uKey
* Renew or recreate the EZTwain Pro trial license in this computer,
* if the Key parameter is a valid trial-renewal key.
* Such keys are valid only for some number of days after issue.
* Contact Dosadi Support (support@dosadi.com) for such a key.

DECLARE LONG TWAIN_SingleMachineLicense IN Eztwain3.dll ;
   STRING sMsg
* If no valid EZTwain Pro license is found on this computer, prompt
* the user with a dialog box asking for a single-machine license key.
* If the user supplies a key, try to record & validate it.
* Return value:
* TRUE if EZTwain Pro is licensed for use on this computer.
* (Note this could be because of a trial license, or an organization license).
* FALSE if EZTwain Pro is not licensed for use on this computer.

DECLARE TWAIN_RegisterApp IN Eztwain3.dll ;
   LONG nMajorNum, ;
   LONG nMinorNum, ;
   LONG nLanguage, ;
   LONG nCountry, ;
   STRING sVersion, ;
   STRING sMfg, ;
   STRING sFamily, ;
   STRING sAppTitle
*
* TWAIN_RegisterApp can be called *AS THE FIRST CALL*, to register the
* application. If this function is not called, the application is given a
* 'generic' registration by EZTWAIN.
* Registration only provides this information to the Source Manager and any
* sources you may open - it is used for debugging, and possibly by some
* sources to give special treatment to certain applications.

*--------- Error Analysis and Reporting ------------------------------------

DECLARE LONG TWAIN_GetResultCode IN Eztwain3.dll
* Return the result code (TWRC_xxx) from the last triplet sent to TWAIN

DECLARE LONG TWAIN_GetConditionCode IN Eztwain3.dll
* Return the condition code from the last triplet sent to TWAIN.
* (To be precise, from the last call to TWAIN_DS below)
* If a source is NOT open, return the condition code of the source manager.

DECLARE LONG TWAIN_UserClosedSource IN Eztwain3.dll
* Return TRUE (1) if during the last acquire the user asked
* the DataSource to close.  0 otherwise of course.
* This flag is cleared each time you start any kind of acquire,
* and it is set if EZTWAIN receives a
* MSG_CLOSEDSREQ message through TWAIN.

DECLARE TWAIN_ErrorBox IN Eztwain3.dll ;
   STRING sMsg
* Post an error message dialog with an OK button.
* pzMsg points to a null-terminated message string.
* The box caption is the current AppTitle - see SetAppTitle.
* If messages are suppressed (see below) this function does nothing.

DECLARE LONG TWAIN_SuppressErrorMessages IN Eztwain3.dll ;
   LONG bYes
* Enable or disable EZTWAIN error messages to the user.
* When bYes = FALSE(0), error messages are displayed.
* When bYes = TRUE(non-0), error messages are suppressed.
* By default, error messages are displayed.
* Returns the previous state of the flag.
*
* EZTWAIN cannot suppress messages from TWAIN or TWAIN device drivers.

DECLARE TWAIN_ReportLastError IN Eztwain3.dll ;
   STRING msg
* If EZTwain has recorded an error and that error has not been
* reported to the user, this function displays a modal error dialog
* with information about that error.
* If msg is non-null and not the empty string, it is included
* in the dialog box.
* Many EZTwain errors record additional details, and those details
* are also inserted in the error dialog.
*
* If the recorded error is EZTEC_NONE (no error) or EZTEC_USER_CANCEL,
* no error dialog is displayed.
* If the recorded error information indicates that the user cancelled
* a TWAIN operation, *or* that the user has already seen an error
* message about the error, then no error dialog is displayed.
*
* This function *clears* the recorded error, whether or
* not it displays a message, by calling TWAIN_ClearError.

DECLARE TWAIN_GetLastErrorText IN Eztwain3.dll ;
   STRING @sMsg
* Get a string that describes the last error detected by EZTwain.
* Note: This function is called by TWAIN_ReportLastError.
* Note: The returned string may contain end-of-line characters.
* The parameter is a string variable (char array in C/C++).
* You are responsible for allocating room for 512 8-bit characters
* in the string variable before calling this function.

DECLARE STRING TWAIN_LastErrorText IN Eztwain3.dll
* Return a string that describes the last error detected by EZTwain -
* see Notes for TWAIN_GetLastErrorText.

DECLARE LONG TWAIN_LastErrorCode IN Eztwain3.dll
* Return the last internal EZTWAIN error code. (see EZTEC_ codes below)

DECLARE TWAIN_ClearError IN Eztwain3.dll
* Set the EZTWAIN internal error code to EZTEC_NONE

DECLARE LONG TWAIN_ReportLeaks IN Eztwain3.dll
* Display a message box if EZTwain can detect any memory leaks.
* Currently this only counts image handles (DIBs) that have been
* allocated but never freed.
* Returns True(1) if a problem is detected, False(0) otherwise.

*//////////////////////////////////////////////////////
* EZTwain Error codes
#DEFINE EZTEC_NONE 0
#DEFINE EZTEC_START_TRIPLET_ERRS 1
#DEFINE EZTEC_CAP_GET 2
#DEFINE EZTEC_CAP_SET 3
#DEFINE EZTEC_DSM_FAILURE 4
#DEFINE EZTEC_DS_FAILURE 5
#DEFINE EZTEC_XFER_FAILURE 6
#DEFINE EZTEC_END_TRIPLET_ERRS 7
#DEFINE EZTEC_OPEN_DSM 8
#DEFINE EZTEC_OPEN_DEFAULT_DS 9
#DEFINE EZTEC_NOT_STATE_4 10
#DEFINE EZTEC_NULL_HCON 11
#DEFINE EZTEC_BAD_HCON 12
#DEFINE EZTEC_BAD_CONTYPE 13
#DEFINE EZTEC_BAD_ITEMTYPE 14
#DEFINE EZTEC_CAP_GET_EMPTY 15
#DEFINE EZTEC_CAP_SET_EMPTY 16
#DEFINE EZTEC_INVALID_HWND 17
#DEFINE EZTEC_PROXY_WINDOW 18
#DEFINE EZTEC_USER_CANCEL 19
#DEFINE EZTEC_RESOLUTION 20
#DEFINE EZTEC_LICENSE 21
#DEFINE EZTEC_JPEG_DLL 22
#DEFINE EZTEC_SOURCE_EXCEPTION 23
#DEFINE EZTEC_LOAD_DSM 24
#DEFINE EZTEC_NO_SUCH_DS 25
#DEFINE EZTEC_OPEN_DS 26
#DEFINE EZTEC_ENABLE_FAILED 27
#DEFINE EZTEC_BAD_MEMXFER 28
#DEFINE EZTEC_JPEG_GRAY_OR_RGB 29
#DEFINE EZTEC_JPEG_BAD_Q 30
#DEFINE EZTEC_BAD_DIB 31
#DEFINE EZTEC_BAD_FILENAME 32
#DEFINE EZTEC_FILE_NOT_FOUND 33
#DEFINE EZTEC_FILE_ACCESS 34
#DEFINE EZTEC_MEMORY 35
#DEFINE EZTEC_JPEG_ERR 36
#DEFINE EZTEC_JPEG_ERR_REPORTED 37
#DEFINE EZTEC_0_PAGES 38
#DEFINE EZTEC_UNK_WRITE_FF 39
#DEFINE EZTEC_NO_TIFF 40
#DEFINE EZTEC_TIFF_ERR 41
#DEFINE EZTEC_PDF_WRITE_ERR 42
#DEFINE EZTEC_NO_PDF 43
#DEFINE EZTEC_GIFCON 44
#DEFINE EZTEC_FILE_READ_ERR 45
#DEFINE EZTEC_BAD_REGION 46
#DEFINE EZTEC_FILE_WRITE 47
#DEFINE EZTEC_NO_DS_OPEN 48
#DEFINE EZTEC_DCXCON 49
#DEFINE EZTEC_NO_BARCODE 50
#DEFINE EZTEC_UNK_READ_FF 51
#DEFINE EZTEC_DIB_FORMAT 52
#DEFINE EZTEC_PRINT_ERR 53
#DEFINE EZTEC_NO_DCX 54
#DEFINE EZTEC_APP_BAD_CON 55
#DEFINE EZTEC_LIC_KEY 56
#DEFINE EZTEC_INVALID_PARAM 57
#DEFINE EZTEC_INTERNAL 58
#DEFINE EZTEC_LOAD_DLL 59
#DEFINE EZTEC_CURL 60
#DEFINE EZTEC_MULTIPAGE_OPEN 61
#DEFINE EZTEC_BAD_SHUTDOWN 62
#DEFINE EZTEC_DLL_VERSION 63
#DEFINE EZTEC_OCR_ERR 64
#DEFINE EZTEC_ONLY_TO_PDF 65
#DEFINE EZTEC_APP_TITLE 66
#DEFINE EZTEC_PATH_CREATE 67
#DEFINE EZTEC_LATE_LIC 68
#DEFINE EZTEC_PDF_PASSWORD 69
#DEFINE EZTEC_PDF_UNSUPPORTED 70
#DEFINE EZTEC_PDF_BAFFLED 71
#DEFINE EZTEC_PDF_INVALID 72
#DEFINE EZTEC_PDF_COMPRESSION 73
#DEFINE EZTEC_NOT_ENOUGH_PAGES 74
#DEFINE EZTEC_DIB_ARRAY_OVERFLOW 75
#DEFINE EZTEC_DEVICE_PAPERJAM 76
#DEFINE EZTEC_DEVICE_DOUBLEFEED 77
#DEFINE EZTEC_DEVICE_COMM 78
#DEFINE EZTEC_DEVICE_INTERLOCK 79




*--------- TWAIN State Control ------------------------------------

DECLARE TWAIN_Shutdown IN Eztwain3.dll
* Shuts down and cleans up all EZTwain operations.
* All memory allocations are freed, all I/O operations
* are completed, any threads are terminated, and
* TWAIN is closed and unloaded.

DECLARE LONG TWAIN_LoadSourceManager IN Eztwain3.dll
* Finds and loads the Data Source Manager, TWAIN.DLL.
* If Source Manager is already loaded, does nothing and returns TRUE(1).
* This can fail if TWAIN.DLL is not installed (in the right place), or
* if the library cannot load for some reason (insufficient memory?) or
* if TWAIN.DLL has been corrupted.

DECLARE LONG TWAIN_OpenSourceManager IN Eztwain3.dll ;
   LONG hwnd
* Opens the Data Source Manager, if not already open.
* If the Source Manager is already open, does nothing and returns TRUE.
* This call will fail if the Source Manager is not loaded.

DECLARE LONG TWAIN_OpenDefaultSource IN Eztwain3.dll
* This opens the source selected in the Select Source dialog.
* If some source is already open, does nothing and returns TRUE.
* Will load and open the Source Manager if needed.
* If this call returns TRUE, TWAIN is in STATE 4 (TWAIN_SOURCE_OPEN)

* These two functions allow you to enumerate the available data sources:
DECLARE LONG TWAIN_GetSourceList IN Eztwain3.dll
* Fetches the list of sources into memory, so they can be returned
* one by one by TWAIN_GetNextSourceName, below.
* Returns TRUE (1) if successful, FALSE (0) otherwise.
* Note: In the special (and very unusual) case of an empty list,
* this function returns TRUE(1) if there was no other error.

DECLARE LONG TWAIN_GetNextSourceName IN Eztwain3.dll ;
   STRING @sName
* Copies the next source name in the list into its parameter.
* The parameter is a string variable (char array in C/C++).
* You are responsible for allocating room for 33 8-bit characters
* in the string variable before calling this function.
* Returns TRUE (1) if successful, FALSE (0) if there are no more.

DECLARE STRING TWAIN_NextSourceName IN Eztwain3.dll
* Returns the next source name in the list.
* Returns the empty string when it comes to the end of the list.

DECLARE LONG TWAIN_GetDefaultSourceName IN Eztwain3.dll ;
   STRING @sName
* Copies the name of the TWAIN default source into its parameter.
* The parameter is a string variable (char array in C/C++).
* You are responsible for allocating room for 33 8-bit characters
* in the string variable before calling this function.
* Normally returns TRUE (1) but will return FALSE (0) if:
*   - the TWAIN Source Manager cannot be loaded & initialized or
*   - there is no current default source (e.g. no sources are installed)

DECLARE STRING TWAIN_DefaultSourceName IN Eztwain3.dll
* Returns the name of the TWAIN default source device, as a string

DECLARE LONG TWAIN_OpenSource IN Eztwain3.dll ;
   STRING sName
* Opens the source with the given name.
* If that source is already open, does nothing and returns TRUE.
* If another source is open, closes it and attempts to open the specified source.
* Will load and open the Source Manager if needed.

DECLARE LONG TWAIN_EnableSource IN Eztwain3.dll ;
   LONG hwnd
* Enables the open Data Source. This posts the source's user interface
* and allows image acquisition to begin.  If the source is already enabled,
* this call does nothing and returns TRUE.

DECLARE LONG TWAIN_DisableSource IN Eztwain3.dll
* Disables the open Data Source, if any.
* This closes the source's user interface.
* If successful or the source is already disabled, returns TRUE(1).

DECLARE LONG TWAIN_CloseSource IN Eztwain3.dll
* Closes the open Data Source, if any.
* If the source is enabled, disables it first.
* If successful or source is already closed, returns TRUE(1).

DECLARE LONG TWAIN_CloseSourceManager IN Eztwain3.dll ;
   LONG hwnd
* Closes the Data Source Manager, if it is open.
* If a source is open, disables and closes it as needed.
* If successful (or if source manager is already closed) returns TRUE(1).

DECLARE LONG TWAIN_UnloadSourceManager IN Eztwain3.dll
* Unloads the Data Source Manager i.e. TWAIN.DLL - releasing
* any associated memory or resources.
* If necessary, it will abort transfers, close the open source
* if any, and close the Source Manager.
* If successful, it returns TRUE(1)


DECLARE LONG TWAIN_IsTransferReady IN Eztwain3.dll

DECLARE LONG TWAIN_EndXfer IN Eztwain3.dll

DECLARE LONG TWAIN_AbortAllPendingXfers IN Eztwain3.dll

*--------- High-level Capability Negotiation Functions --------

* These functions should only be called in State 4 (TWAIN_SOURCE_OPEN)

DECLARE LONG TWAIN_SetXferCount IN Eztwain3.dll ;
   LONG nXfers
* Negotiate with open Source the number of images application will accept.
* nXfers = -1 means any number
* Returns: TRUE(1) for success, FALSE(0) for failure.

*----- Unit of Measure
* TWAIN unit codes (from twain.h)
#DEFINE TWUN_INCHES 0
#DEFINE TWUN_CENTIMETERS 1
#DEFINE TWUN_PICAS 2
#DEFINE TWUN_POINTS 3
#DEFINE TWUN_TWIPS 4
#DEFINE TWUN_PIXELS 5

DECLARE LONG TWAIN_GetCurrentUnits IN Eztwain3.dll
* Return the current unit of measure: inches, cm, pixels, etc.
* Many TWAIN parameters such as resolution are set and returned
* in the current unit of measure.
* There is no error return - in case of error it returns 0 (TWUN_INCHES)

DECLARE LONG TWAIN_SetUnits IN Eztwain3.dll ;
   LONG nUnits
DECLARE LONG TWAIN_SetCurrentUnits IN Eztwain3.dll ;
   LONG nUnits
* Set the current unit of measure for the source.
* Returns: TRUE(1) for success, FALSE(0) for failure.
* Common unit codes (TWUN_*) are given above.
* Notes:
* 1. Most sources do not support all units, some support *only* inches!
* 2. If you want to get or set resolution in DPI (dots per *inch*), make
* sure the current units are inches, or you might get Dots-Per-cm!
* 3. Ditto (same comment) for ImageLayout, see below.

DECLARE LONG TWAIN_GetBitDepth IN Eztwain3.dll
* Get the current bitdepth, which can depend on the current PixelType.
* Bit depth is per color channel e.g. 24-bit RGB has bit depth 8.
* If anything goes wrong, this function returns 0.

DECLARE LONG TWAIN_SetBitDepth IN Eztwain3.dll ;
   LONG nBits
* (Try to) set the current bitdepth (for the current pixel type).
* Note: You should set a PixelType, then set the bitdepth for that type.
* Returns: TRUE(1) for success, FALSE(0) for failure.

*------- TWAIN Pixel Types (from twain.h)
#DEFINE TWPT_BW 0
#DEFINE TWPT_GRAY 1
#DEFINE TWPT_RGB 2
#DEFINE TWPT_PALETTE 3
#DEFINE TWPT_CMY 4
#DEFINE TWPT_CMYK 5

DECLARE LONG TWAIN_GetPixelType IN Eztwain3.dll
* Ask the source for the current pixel type.
* If anything goes wrong (it shouldn't), this function returns 0 (TWPT_BW).

DECLARE LONG TWAIN_SetPixelType IN Eztwain3.dll ;
   LONG nPixType
DECLARE LONG TWAIN_SetCurrentPixelType IN Eztwain3.dll ;
   LONG nPixType
* Try to set the current pixel type for acquisition.
* The source may select this pixel type, but don't assume it will.

DECLARE DOUBLE TWAIN_GetCurrentResolution IN Eztwain3.dll
* Ask the source for the current (horizontal) resolution.
* Resolution is in dots per current unit! (See TWAIN_GetCurrentUnits above)
* If anything goes wrong (it shouldn't) this function returns 0.0

DECLARE DOUBLE TWAIN_GetXResolution IN Eztwain3.dll
DECLARE DOUBLE TWAIN_GetYResolution IN Eztwain3.dll
* Returns the current horizontal or vertical resolution, in dots per *current unit*.
* In the event of failure, returns 0.0.

DECLARE LONG TWAIN_SetResolution IN Eztwain3.dll ;
   DOUBLE dRes
DECLARE LONG TWAIN_SetResolutionInt IN Eztwain3.dll ;
   LONG nRes
DECLARE LONG TWAIN_SetCurrentResolution IN Eztwain3.dll ;
   DOUBLE dRes
* Try to set the current resolution (in both x & y).
* Resolution is in dots per current unit! (See TWAIN_GetCurrentUnits above)
* Note: The source may select this resolution, but don't assume it will.

* You can also set the resolution in X and Y separately, if your TWAIN
* device can handle this:
DECLARE LONG TWAIN_SetXResolution IN Eztwain3.dll ;
   DOUBLE dxRes
DECLARE LONG TWAIN_SetYResolution IN Eztwain3.dll ;
   DOUBLE dyRes

DECLARE LONG TWAIN_SetContrast IN Eztwain3.dll ;
   DOUBLE dCon
* Try to set the current contrast for acquisition.
* The TWAIN standard *says* that the range for this cap is -1000 ... +1000

DECLARE LONG TWAIN_SetBrightness IN Eztwain3.dll ;
   DOUBLE dBri
* Try to set the current brightness for acquisition.
* The TWAIN standard *says* that the range for this cap is -1000 ... +1000

DECLARE LONG TWAIN_SetThreshold IN Eztwain3.dll ;
   DOUBLE dThresh
* Try to set the threshold for black and white scanning.
* Should only affect 1-bit scans i.e. PixelType == TWPT_BW.
* The TWAIN default threshold value is 128.
* After staring at the TWAIN 1.6 spec for a while, I imagine that it implies
* that for 8-bit samples, values >= nThresh are thresholded to 1, others to 0.

DECLARE DOUBLE TWAIN_GetCurrentThreshold IN Eztwain3.dll
* Try to get and return the current value (MSG_GETCURRENT) of the
* ICAP_THRESHOLD capability.  If this fails for any reason, it
* will return -1.  *VERSIONS BEFORE 2.65 RETURNED 128.0*

*--------------------------------------------------------------
* Automatic post-processing of scanned pages
*
*
* Automatic deskewing of scanned pages
*
DECLARE TWAIN_SetAutoDeskew IN Eztwain3.dll ;
   LONG nMode
* Select the 'auto-deskew' mode.
* Auto-deskew attempts to straighten up scans that are slightly crooked,
* up to about 10 degrees.
* The currently defined modes are:
*  0   - no auto deskew (default)
*  1   - auto deskew using EZTwain software algorithms

DECLARE LONG TWAIN_GetAutoDeskew IN Eztwain3.dll
* Return the current AutoDeskew mode.

*
* Automatic discarding of blank pages
*
DECLARE TWAIN_SetBlankPageMode IN Eztwain3.dll ;
   LONG nMode
DECLARE LONG TWAIN_GetBlankPageMode IN Eztwain3.dll
* Sets or gets the 'Skip Blank Pages' mode.
* The currently defined modes are:
*   0 = no special treatment for blank pages (default)
*   1 = blank pages are discarded by TWAIN_AcquireMultipageFile.
* See TWAIN_SetBlankPageThreshold below for more details.

DECLARE TWAIN_SetBlankPageThreshold IN Eztwain3.dll ;
   DOUBLE dDarkness
DECLARE DOUBLE TWAIN_GetBlankPageThreshold IN Eztwain3.dll
* Sets or gets the blank page 'darkness' threshold.
* In 'Skip Blank Pages' mode (see above), each page of a multipage
* scan is measured for 'darkness'.  If the darkness of a page
* is below the BlankPageThreshold, it is considered blank.
* See the related functions DIB_IsBlank and DIB_Darkness.
* 
* The default BlankPageThreshold is 0.02 (= 2% dark pixels).

DECLARE LONG TWAIN_BlankDiscardCount IN Eztwain3.dll
* Return the number of blank pages discarded (skipped) during
* the most recent multipage scan.
* Of course this only reports pages skipped by software, not
* any pages discarded as 'blank' inside the scanner - if such
* a feature is enabled.
*
* Automatic cropping of scanned pages
*
DECLARE TWAIN_SetAutoCrop IN Eztwain3.dll ;
   LONG nMode
DECLARE LONG TWAIN_GetAutoCrop IN Eztwain3.dll
* Select the AutoCrop mode.
* Auto-crop attempts to trim off black areas on the outside
* edges of each incoming image during scanning.
* It will not be effective on scanners that have white
* background outside the scanned document.
* The currently defined modes are:
*  0   - no auto crop (default)
*  1   - auto crop using EZTwain software algorithms
*  2   - use scanner autocrop if possible, otherwise no autocrop
*  3   - use scanner autocrop if possible, otherwise do software autocrop.

*
* Automatic contrast adjustment of scanned pages
*
DECLARE TWAIN_SetAutoContrast IN Eztwain3.dll ;
   LONG nMode
DECLARE LONG TWAIN_GetAutoContrast IN Eztwain3.dll
* Select the AutoContrast mode.
* Automatically adjust the contrast of each image - see
* DIB_AutoContrast for more information.
* The currently defined modes are:
*  0   - no autocontrast.
*  1   - autocontrast using EZTwain software algorithms

*
* Automatic OCR of scanned pages.
*
DECLARE TWAIN_SetAutoOCR IN Eztwain3.dll ;
   LONG nMode
DECLARE LONG TWAIN_GetAutoOCR IN Eztwain3.dll
* Sets or gets the auto-OCR mode
* By default this mode is 0 = OFF.
* When this mode is on (1), EZTwain applies OCR, if available, to each incoming
* scanned page or image and temporarily stores the result.  In this mode,
* if you are scanning directly to PDF format using TWAIN_AcquireToFilename
* or TWAIN_AcquireMultipageFile, the OCR'd text is also written to each
* PDF page as invisible text, to facilitate indexing and searching.
* If you are scanning individual pages you can call OCR_Text or OCR_GetText
* to retrieve the text found on the most recently scanned page.
* In this mode, any Acquire call discards any previous OCR text.
*
* The currently selected OCR engine is used: See OCR_SelectEngine and co.
* Caution: If OCR fails for some reason in auto-OCR mode, an error is recorded
* (see TWAIN_LastErrorCode, TWAIN_ReportLastError) but the scanning function
* may report success.

*
* Automatic negation of scanned pages
*
DECLARE TWAIN_SetAutoNegate IN Eztwain3.dll ;
   LONG bYes
DECLARE LONG TWAIN_GetAutoNegate IN Eztwain3.dll
* Set or get the "AutoNegate" flag: When this flag is set (non-zero)
* EZTwain automatically 'negates' any B&W scanned image that is > 80% black
* i.e. it exchanges black & white in the image.
* This flag is TRUE (1) by default.

*--------------------------------------------------------------


DECLARE LONG TWAIN_SetXferMech IN Eztwain3.dll ;
   LONG mech
DECLARE LONG TWAIN_XferMech IN Eztwain3.dll
* Try to set or get the transfer mode - one of the following:
#DEFINE XFERMECH_NATIVE 0
#DEFINE XFERMECH_FILE 1
#DEFINE XFERMECH_MEMORY 2
* You should not need to set this mode directly - using
* TWAIN_Acquire, TWAIN_AcquireNative and TWAIN_AcquireFile will set
* the appropriate transfer mode for you.

DECLARE LONG TWAIN_SupportsFileXfer IN Eztwain3.dll
* Returns TRUE(1) if the open DS claims to support file transfer mode (XFERMECH_FILE)
* Returns FALSE(0) otherwise.
* This mode is optional.  If TRUE, you can use AcquireFile.

DECLARE LONG TWAIN_SetPaperSize IN Eztwain3.dll ;
   LONG nPaper
* During the next scan, request that the scanner scan the specified paper size.
* Most scanners support the first few paper sizes, excluding any that are
* larger than their physical scan capacity.
* To determine the paper sizes supported by a particular scanner, see
* "Working with Capabilities" in the EZTwain User Guide.
*
* Note - These are synonyms for the TWSS_* constants in TWAIN.H
#DEFINE PAPER_NONE 0
#DEFINE PAPER_A4LETTER 1
#DEFINE PAPER_A4 1
#DEFINE PAPER_B5LETTER 2
#DEFINE PAPER_JISB5 2
#DEFINE PAPER_USLETTER 3
#DEFINE PAPER_USLEGAL 4
#DEFINE PAPER_A5 5
#DEFINE PAPER_B4 6
#DEFINE PAPER_ISOB4 6
#DEFINE PAPER_B6 7
#DEFINE PAPER_ISOB6 7
#DEFINE PAPER_USLEDGER 9
#DEFINE PAPER_USEXECUTIVE 10
#DEFINE PAPER_A3 11
#DEFINE PAPER_B3 12
#DEFINE PAPER_ISOB3 12
#DEFINE PAPER_A6 13
#DEFINE PAPER_C4 14
#DEFINE PAPER_C5 15
#DEFINE PAPER_C6 16
#DEFINE PAPER_4A0 17
#DEFINE PAPER_2A0 18
#DEFINE PAPER_A0 19
#DEFINE PAPER_A1 20
#DEFINE PAPER_A2 21
#DEFINE PAPER_A7 22
#DEFINE PAPER_A8 23
#DEFINE PAPER_A9 24
#DEFINE PAPER_A10 25
#DEFINE PAPER_ISOB0 26
#DEFINE PAPER_ISOB1 27
#DEFINE PAPER_ISOB2 28
#DEFINE PAPER_ISOB5 29
#DEFINE PAPER_ISOB7 30
#DEFINE PAPER_ISOB8 31
#DEFINE PAPER_ISOB9 32
#DEFINE PAPER_ISOB10 33
#DEFINE PAPER_JISB0 34
#DEFINE PAPER_JISB1 35
#DEFINE PAPER_JISB2 36
#DEFINE PAPER_JISB3 37
#DEFINE PAPER_JISB4 38
#DEFINE PAPER_JISB6 39
#DEFINE PAPER_JISB7 40
#DEFINE PAPER_JISB8 41
#DEFINE PAPER_JISB9 42
#DEFINE PAPER_JISB10 43
#DEFINE PAPER_C0 44
#DEFINE PAPER_C1 45
#DEFINE PAPER_C2 46
#DEFINE PAPER_C3 47
#DEFINE PAPER_C7 48
#DEFINE PAPER_C8 49
#DEFINE PAPER_C9 50
#DEFINE PAPER_C10 51
#DEFINE PAPER_USSTATEMENT 52
#DEFINE PAPER_BUSINESSCARD 53

DECLARE LONG TWAIN_GetPaperDimensions IN Eztwain3.dll ;
   LONG nPaper, ;
   LONG nUnits, ;
   DOUBLE @pdW, ;
   DOUBLE @pdH
* Retrieve the width and height of a standard paper size.
* 1st parameter is a PAPER_ code.
* 2nd parameter is a unit code, TWUN_INCHES, TWUN_CENTIMETERS, etc.
* 3rd & 4th parameter are pointers to double variables that receive the width
* and height of the specified paper size, in the specified units.
* Returns TRUE(1) if successful, FALSE(0) otherwise.

*-------- Document Feeder -------

DECLARE LONG TWAIN_HasFeeder IN Eztwain3.dll
* Returns TRUE(1) if the source indicates it has a document feeder.
* Note: A FALSE(0) is returned if the source does not handle this inquiry.

DECLARE LONG TWAIN_ProbablyHasFlatbed IN Eztwain3.dll
* Returns TRUE(1) if we think the source has a flatbed available.
* It's a good guess but not a guarantee - we could be wrong.

DECLARE LONG TWAIN_IsFeederSelected IN Eztwain3.dll
* Returns TRUE(1) if the document feeder is selected.

DECLARE LONG TWAIN_SelectFeeder IN Eztwain3.dll ;
   LONG bYes
* (Try to) select or deselect the document feeder.
* The document feeder, if any, is selected if bYes is non-zero.
* The flatbed, if any, is selected if bYes is zero.
* Note: A few of the scanners that have both a flatbed and 
* a feeder ignore this request in some circumstances.
* Returns TRUE(1) if successful, FALSE(0) otherwise.

DECLARE LONG TWAIN_IsAutoFeedOn IN Eztwain3.dll
* Returns TRUE(1) if automatic feeding is enabled, otherwise FALSE(0).
* Make sure the feeder is selected before calling this function.

DECLARE LONG TWAIN_SetAutoFeed IN Eztwain3.dll ;
   LONG bYes
* (Try to) turn on/off automatic feeding thru the feeder.
* Returns TRUE(1) if successful, FALSE(0) otherwise.
* Note: TWAIN_AcquireMultipageFile calls TWAIN_SetAutoFeed(True).

DECLARE LONG TWAIN_IsFeederLoaded IN Eztwain3.dll
* Returns TRUE(1) if there are documents in the feeder.
* Make sure the feeder is selected before calling this function.

DECLARE LONG TWAIN_IsPaperDetectable IN Eztwain3.dll
* Returns TRUE(1) if the open device (better have one open!)
* is capable of detecting paper in its feeder.
* If not, returns FALSE.
* Displays an error dialog if called with no scanner open.

DECLARE LONG TWAIN_SetAutoScan IN Eztwain3.dll ;
   LONG bYes
* Setting this to TRUE gives the scanner permission to 'scan ahead'
* i.e. to pull pages from the feeder and scan them before 
* they have been requested.  On high-speed scanners, you may
* have to enable AutoScan to achieve the maximum scanning rate.
* Returns TRUE(1) if successful, FALSE(0) otherwise.
* This call will fail on most flatbeds & cameras, and some 'feeder'
* scanners.
* TWAIN_AcquireMultipageFile calls TWAIN_SetAutoScan(True).

*-------- Duplex Scanning -------

DECLARE LONG TWAIN_GetDuplexSupport IN Eztwain3.dll
* Query the device for duplex scanning support.
*   Return values:
* 0    = no support (or error, or query not recognized)
* 1    = 1-pass duplex
* 2    = 2-pass duplex

DECLARE LONG TWAIN_EnableDuplex IN Eztwain3.dll ;
   LONG bYes
* Enable (bYes not 0) or disable (bYes=0) duplex scanning.
* Returns TRUE(1) if successful, FALSE(0) otherwise.

DECLARE LONG TWAIN_IsDuplexEnabled IN Eztwain3.dll
* Returns TRUE(1) if the device supports duplex scanning
* and duplex scanning is enabled.  FALSE(0) otherwise.

*--------- Other 'exotic' capabilities --------

DECLARE LONG TWAIN_HasControllableUI IN Eztwain3.dll
* Return 1 if source claims UI can be hidden (see SetHideUI above)
* Return 0 if source says UI *cannot* be hidden
* Return -1 if source (pre TWAIN 1.6) cannot answer the question.

DECLARE LONG TWAIN_SetIndicators IN Eztwain3.dll ;
   LONG bVisible
* Tell the device to show or hide progress indicators during acquisition.
* Default is TRUE, which gives the device permission to show a progress
* box or similar, but does not require it.
* Returns: TRUE(1) for success, FALSE(0) for failure.

DECLARE LONG TWAIN_Compression IN Eztwain3.dll
DECLARE LONG TWAIN_SetCompression IN Eztwain3.dll ;
   LONG compression
* Set/Get compression style for transferred data
* Set returns TRUE(1) for success, FALSE(0) for failure.

DECLARE LONG TWAIN_Tiled IN Eztwain3.dll
DECLARE LONG TWAIN_SetTiled IN Eztwain3.dll ;
   LONG bTiled
* Set/Get whether source does memory xfer via strips or tiles.
* bTiled = TRUE if it uses tiles for transfer.
* Set returns: TRUE(1) for success, FALSE(0) for failure.

DECLARE LONG TWAIN_PlanarChunky IN Eztwain3.dll
DECLARE LONG TWAIN_SetPlanarChunky IN Eztwain3.dll ;
   LONG shape
* Set/Get current pixel shape (TWPC_CHUNKY or TWPC_PLANAR), or -1.
* Set returns TRUE(1) for success, FALSE(0) for failure.

#DEFINE CHUNKY_PIXELS 0
#DEFINE PLANAR_PIXELS 1

DECLARE LONG TWAIN_PixelFlavor IN Eztwain3.dll
DECLARE LONG TWAIN_SetPixelFlavor IN Eztwain3.dll ;
   LONG flavor
* Set/Get pixel 'flavor' - whether a '0' pixel value means black or white:
* Set returns: TRUE(1) for success, FALSE(0) for failure.

#DEFINE CHOCOLATE_PIXELS 0
#DEFINE VANILLA_PIXELS 1


DECLARE LONG TWAIN_SetLightPath IN Eztwain3.dll ;
   LONG bTransmissive
* Tries to select transparent or reflective media on the open source.
* A parameter of TRUE(1) means transparent, FALSE(0) means reflective.
* Returns: TRUE(1) for success, FALSE(0) for failure.

DECLARE LONG TWAIN_SetAutoBright IN Eztwain3.dll ;
   LONG bOn
DECLARE LONG TWAIN_SetGamma IN Eztwain3.dll ;
   DOUBLE dGamma
DECLARE LONG TWAIN_SetShadow IN Eztwain3.dll ;
   DOUBLE d
DECLARE LONG TWAIN_SetHighlight IN Eztwain3.dll ;
   DOUBLE d
* Set auto-brightness, gamma, shadow, and highlight values.
* Refer to the TWAIN specification for definitions of these settings.
* Returns: TRUE(1) for success, FALSE(0) for failure.

*--------- Image Layout (Region of Interest) --------

DECLARE TWAIN_SetRegion IN Eztwain3.dll ;
   DOUBLE L, ;
   DOUBLE T, ;
   DOUBLE R, ;
   DOUBLE B
* Specify the region to be acquired, in current unit of measure.
* This is the recommended most-general way to scan a region.
* Tries to use TWAIN_SetImageLayout and TWAIN_SetFrame (see below).
* If the device ignores those, the specified region is extracted
* after each scan completes, by software cropping. (DIB_RegionCopy)
* In other words, this call should *always* produce scans of
* the requested region, unless you specify a region in inches or
* centimeters and the device is a camera whose only unit is pixels.

DECLARE TWAIN_ResetRegion IN Eztwain3.dll
* Clear any region set with TWAIN_SetRegion above.

DECLARE LONG TWAIN_SetImageLayout IN Eztwain3.dll ;
   DOUBLE L, ;
   DOUBLE T, ;
   DOUBLE R, ;
   DOUBLE B
* Specify the area to scan, sometimes called the ROI (Region of Interest)
* Returns: TRUE(1) for success, FALSE(0) for failure.
* This call is only valid in State 4.
* L, T, R, B = distance to left, top, right, and bottom edge of
* area to scan, measured in the current unit of measure,
* from the top-left corner of the 'original page' (TWAIN 1.6 8-22)

DECLARE LONG TWAIN_GetImageLayout IN Eztwain3.dll ;
   DOUBLE @L, ;
   DOUBLE @T, ;
   DOUBLE @R, ;
   DOUBLE @B
DECLARE LONG TWAIN_GetDefaultImageLayout IN Eztwain3.dll ;
   DOUBLE @L, ;
   DOUBLE @T, ;
   DOUBLE @R, ;
   DOUBLE @B
* Get the current or default (power-on) area to scan.
* Returns: TRUE(1) for success, FALSE(0) for failure.
* This call is valid in States 4-6.
* Supposedly the returned values (see above)
* are in the current unit of measure (ICAP_UNITS), but I observe that
* many DS's ignore ICAP_UNITS when dealing with Image Layout.

DECLARE LONG TWAIN_ResetImageLayout IN Eztwain3.dll
* Reset the area to scan to the default (power-on) settings.
* This call is only valid in State 4.
* Returns: TRUE(1) for success, FALSE(0) for failure.


* Closely related:
DECLARE LONG TWAIN_SetFrame IN Eztwain3.dll ;
   DOUBLE L, ;
   DOUBLE T, ;
   DOUBLE R, ;
   DOUBLE B
* This is an alternative way to set the scan area.
* Some scanners will respond to this instead of SetImageLayout.
* Returns: TRUE(1) for success, FALSE(0) for failure.
* This call is only valid in State 4.
* L, T, R, B = distance to left, top, right, and bottom edge of
* area to scan, measured in the current unit of measure,


*--------- Tone Response Curves --------

DECLARE LONG TWAIN_SetGrayResponse IN Eztwain3.dll ;
   STRING @pcurve
* Define a translation of gray pixel values.
* When device digitizes a pixel with value V, that
* pixel is translated to value pcurve[V] before it
* is returned to the application.
* Device must be open (State 4),
* Current PixelType must be TWPT_GRAY or TWPT_RGB,
* current BitDepth should be 8.
* pcurve must be a table (array, vector) of 256 entries.
* Returns: TRUE(1) for success, FALSE(0) for failure.

DECLARE LONG TWAIN_SetColorResponse IN Eztwain3.dll ;
   STRING @pred, ;
   STRING @pgreen, ;
   STRING @pblue
* Define a translation of color values.
* Like TWAIN_SetGrayResponse (above) but separate translation can
* be applied to each color channel.
* Returns: TRUE(1) for success, FALSE(0) for failure.

DECLARE LONG TWAIN_ResetGrayResponse IN Eztwain3.dll
DECLARE LONG TWAIN_ResetColorResponse IN Eztwain3.dll
* These two functions reset the response curve to map every
* value V to itself i.e. a 'do nothing' translation.
* Returns: TRUE(1) for success, FALSE(0) for failure.

*--------- Barcode Recognition -------

DECLARE LONG BARCODE_IsAvailable IN Eztwain3.dll
* TRUE(1) if barcode recognition is available.
* Returns FALSE(0) otherwise.

DECLARE LONG BARCODE_Version IN Eztwain3.dll
* Return the barcode module version * 100.

* Barcode recognition engines supported by EZTwain:
#DEFINE EZBAR_ENGINE_NONE 0
#DEFINE EZBAR_ENGINE_DOSADI 1
#DEFINE EZBAR_ENGINE_AXTEL 2
#DEFINE EZBAR_ENGINE_LEADTOOLS 3
#DEFINE EZBAR_ENGINE_BLACKICE 4

* The Axtel barcode engine has been discontinued by Axtel.
* The LEADTOOLS engine must be separately licensed from LEADTOOLS - www.leadtools.com
* The Black Ice barcode engine must be separately licensed from Black Ice. 

DECLARE LONG BARCODE_IsEngineAvailable IN Eztwain3.dll ;
   LONG nEngine
DECLARE LONG BARCODE_SelectEngine IN Eztwain3.dll ;
   LONG nEngine
DECLARE LONG BARCODE_SelectedEngine IN Eztwain3.dll

DECLARE STRING BARCODE_EngineName IN Eztwain3.dll ;
   LONG nEngine
* Returns the short name ("None", "Dosadi", "Axtel", "LEADTOOLS", "Black Ice") of the specified
* engine, or the empty string if nEngine is not a recognized barcode engine code.

DECLARE BARCODE_SetLicenseKey IN Eztwain3.dll ;
   STRING sKey
* Supply your license key for the currently selected engine.
* The Dosadi engine does not currently require a key.
* For LeadTools, this is a 1D Barcode Module key obtained from LeadTools

DECLARE LONG BARCODE_ReadableCodes IN Eztwain3.dll
* Return the sum of the barcode types recognized by the current selected engine.
*
* Barcode types:
#DEFINE EZBAR_EAN_13 1
#DEFINE EZBAR_EAN_8 2
#DEFINE EZBAR_UPCA 4
#DEFINE EZBAR_UPCE 8
#DEFINE EZBAR_CODE_39 16
#DEFINE EZBAR_CODE_39FA 32
#DEFINE EZBAR_CODE_128 64
#DEFINE EZBAR_CODE_I25 128
#DEFINE EZBAR_CODA_BAR 256
#DEFINE EZBAR_UCCEAN_128 512
#DEFINE EZBAR_CODE_93 1024
#DEFINE EZBAR_ANY -1

DECLARE STRING BARCODE_TypeName IN Eztwain3.dll ;
   LONG nType
* Return a human-readable name for the specified barcode type/symbology.

DECLARE LONG BARCODE_SetDirectionFlags IN Eztwain3.dll ;
   LONG nDirFlags
DECLARE LONG BARCODE_GetDirectionFlags IN Eztwain3.dll
DECLARE LONG BARCODE_AvailableDirectionFlags IN Eztwain3.dll
* Set/Get the directions the engine will scan for barcodes.
* The default is left-to-right ONLY.
* Scanning for barcodes in multiple directions can slow the
* recognition process.  BARCODE_SetDirectionFlags will return TRUE if
* completely successful, FALSE if any direction is invalid or not supported.
* Setting the direction flags to -1 is interpreted as "select all supported
* directions."

* Barcode direction flags - can be or'ed together
#DEFINE EZBAR_LEFT_TO_RIGHT 1
#DEFINE EZBAR_RIGHT_TO_LEFT 2
#DEFINE EZBAR_TOP_TO_BOTTOM 4
#DEFINE EZBAR_BOTTOM_TO_TOP 8
#DEFINE EZBAR_DIAGONAL 16
* some common combinations:
#DEFINE EZBAR_HORIZONTAL 3
#DEFINE EZBAR_VERTICAL 12

DECLARE BARCODE_SetZone IN Eztwain3.dll ;
   LONG x, ;
   LONG y, ;
   LONG w, ;
   LONG h
* Restrict barcode recognition to one zone (in pixels) of each image.
* Coordinates are left pixel, top pixel, width and height in pixels.

DECLARE BARCODE_NoZone IN Eztwain3.dll
* Cancel any zone restriction - subsequent barcode recognition
* applies to the entire image.

DECLARE LONG BARCODE_Recognize IN Eztwain3.dll ;
   LONG hdib, ;
   LONG nMaxCount, ;
   LONG nType
* Find and recognize barcodes in the given image.
* Don't look for more than nMaxCount barcodes (-1 means 'any number')
* Expect barcodes of the specified type (-1 means 'any recognized type')
* You can add or 'or' together barcode types.
*
* Return values:
*   n>0    n barcodes found
*   0      no barcodes found
*  -1      barcode services not available.
*                                 -2                                                                  -not used-
*  -3      invalid or null image
*                                 -4                                                                  memory error (low memory?)
*  -5                                                               internal error, or error from 3rd party barcode engine.

DECLARE STRING BARCODE_Text IN Eztwain3.dll ;
   LONG n
* Return the text of the nth barcode recognized by the last BARCODE_Recognize.
* barcodes are numbered from 0.
* If there is any problem of any kind, returns the empty string.

DECLARE LONG BARCODE_GetText IN Eztwain3.dll ;
   LONG n, ;
   STRING @Text
* Get the text of the nth barcode recognized by the last BARCODE_Recognize.
* Please allow 64 characters in your text buffer.  Use a smaller buffer
* only if you *know* that the barcode type is limited to shorter strings.

DECLARE LONG BARCODE_Type IN Eztwain3.dll ;
   LONG n
* Return the type (symbology) of the nth barcode recognized.

DECLARE LONG BARCODE_GetRect IN Eztwain3.dll ;
   LONG n, ;
   DOUBLE @L, ;
   DOUBLE @T, ;
   DOUBLE @R, ;
   DOUBLE @B
* Get the rectangle bounding the nth barcode found in the last BARCODE_Recognize.
* Returns TRUE(1) if successful, FALSE(0) otherwise.  The only likely cause
* of a FALSE return would be an invalid value of n, or a null reference.
* L    = left edge
* T    = top edge
* R    = right edge
* B    = bottom edge
* Note: Returned coordinates are in pixels, relative to the upper-left corner
* of the image given to BARCODE_Recognize.

*--------- OCR (Optical Character Recognition) -------

* Note: Requires the Transym OCR engine (TOCR) which must be separately
* licensed from Transym - See www.transym.com

DECLARE LONG OCR_IsAvailable IN Eztwain3.dll
* TRUE(1) if OCR recognition is available in some form.
* Returns FALSE(0) otherwise.

DECLARE LONG OCR_Version IN Eztwain3.dll
* Returns version * 100 of the EZTwain OCR module.

* ----- OCR engines supported by EZTwain -----
#DEFINE EZOCR_ENGINE_NONE 0
#DEFINE EZOCR_ENGINE_TRANSYM 1

DECLARE LONG OCR_IsEngineAvailable IN Eztwain3.dll ;
   LONG nEngine
DECLARE LONG OCR_SelectEngine IN Eztwain3.dll ;
   LONG nEngine
DECLARE LONG OCR_SelectedEngine IN Eztwain3.dll
DECLARE LONG OCR_SelectDefaultEngine IN Eztwain3.dll

DECLARE STRING OCR_EngineName IN Eztwain3.dll ;
   LONG nEngine
* Returns the short name ("None", "Transym TOCR") of the specified
* engine, or the empty string if nEngine is not a recognized OCR engine code.

DECLARE OCR_SetEngineKey IN Eztwain3.dll ;
   STRING sKey
* Set the license key to be passed to the OCR engine.
* * If you are using the reseller version of Transym's TOCR, pass the
*   RegNo provided by Transym, as a string e.g. "0123-4567-89AB-CDEF"

DECLARE OCR_SetLineBreak IN Eztwain3.dll ;
   STRING sEOL
* Set the character sequence to use for line breaks in
* the returned OCR'd text (as returned by OCR_Text and OCR_GetText).
*
* The default OCR line break is \n (LF, 0x0A)
* Other commonly used line breaks are \r (CR, 0x0D) or CRLF.
* Set this *before* doing OCR - it does not modify already
* recognized text.

DECLARE LONG OCR_RecognizeDib IN Eztwain3.dll ;
   LONG hdib
DECLARE LONG OCR_RecognizeDibZone IN Eztwain3.dll ;
   LONG hdib, ;
   LONG x, ;
   LONG y, ;
   LONG w, ;
   LONG h
* Find and recognize text in the given image, or
* in a designated zone of an image.
* Coordinates are left pixel, top pixel, width & height in pixels.
*
* Return values:
*   0                                                               no error, but no text found
*   n > 0                         n characters found (including spaces and returns)
*  -1                                                               OCR services not available
*  -3                                                               invalid or null image
*  -5                                                               internal error or error returned by OCR engine
*
* In case of error, call TWAIN_ReportLastError to display details,
* or call TWAIN_LastErrorCode and related functions.

DECLARE STRING OCR_Text IN Eztwain3.dll
* Return the text found by the last OCR_RecognizeDib
* If there is any problem of any kind, returns the empty string.

DECLARE LONG OCR_GetText IN Eztwain3.dll ;
   STRING @TextBuffer, ;
   LONG nBufLen
* Read the text recognized by the last OCR_RecognizeDib
* into the TextBuffer, which is allocated to hold nBufLen chars.
* Returns the number of characters actually returned.
* Always appends a trailing 0 (NUL).
* Will return 0 if the available text does not fit.

DECLARE LONG OCR_TextLength IN Eztwain3.dll
* Returns the number of characters in OCR_Text.
* Does not count the terminal NUL,
* for those of you working with C-style strings.

DECLARE LONG OCR_TextOrientation IN Eztwain3.dll
* Returns the orientation of the text found by the last OCR_RecognizeDib.
* The value is the number of degrees clockwise that the input
* image was auto-rotated before OCR was performed.
* Currently, the returned value is always a multiple of 90,
* The only possible values are 0, 90, 180 and 270.
* Example: If the original was turned 90 degrees clockwise before scanning,
* it will be auto-rotated 90 degrees *counter-clockwise* before OCR, so
* then the value of this function will be 270.

DECLARE LONG OCR_GetCharPositions IN Eztwain3.dll ;
   STRING @charx, ;
   STRING @chary
DECLARE LONG OCR_GetCharSizes IN Eztwain3.dll ;
   STRING @charw, ;
   STRING @charh
* Return the coordinates or sizes of the characters found by the last
* OCR_RecognizeDib call.
* For each character of the string returned by OCR_Text or OCR_GetText,
* these functions return the x and y coordinates in the array charx and chary,
* and the width and height in the arrays charw and charh.
* So (charx[i],chary[i]) will be the position of the ith character.
* Coordinates are for the top-left corner of the character, relative
* to the top-left corner of the OCR'd image.
* Width and height are in pixels.
*
* Please make *sure* that you pass in (the address/reference of)
* two arrays allocated to hold n values, where n is the return
* value from the last call to OCR_Recognize.

DECLARE OCR_GetResolution IN Eztwain3.dll ;
   DOUBLE @xdpi, ;
   DOUBLE @ydpi
* Return the resolution (in DPI) of the last image given to OCR_RecognizeDib.
* Useful for translating pixel coordinates and sizes into physical (inch) values.

DECLARE OCR_ClearText IN Eztwain3.dll
* Clear any currently stored OCR text.

DECLARE LONG OCR_WritePage IN Eztwain3.dll ;
   LONG hdib
* If an OCR engine is selected and available, and there is
* a PDF file open for writing (by TWAIN_BeginMultipageFile), then
* this function OCRs the image, and writes both the image and
* the text to the output PDF.
*
* Returns TRUE if successful, FALSE otherwise:
* In case of error, call TWAIN_ReportLastError to display details,
* or call TWAIN_LastErrorCode and related functions.

DECLARE LONG OCR_WriteTextToPDF IN Eztwain3.dll
* Write the text from the last OCR to the next PDF page.
* Returns TRUE if successful, FALSE in case of error.
* If there is no OCR text to write, does nothing & returns TRUE.

*--------- Fun With Containers --------

* Capability values are passed thru the TWAIN API in complex global
* memory structures called 'containers'.  EZTWAIN abstracts these
* containers with a handle (an integer) called an HCONTAINER.
* If you are coding in VB or similar, this is a 32-bit integer.
* The following functions provide reasonably comprehensive access
* to the contents of containers.  See also TWAIN_Get, TWAIN_Set.
*
* There are four shapes of containers, which I call 'formats'.
* Depending on its format, a container holds some 'items' - these
* are simple data values, all the same type in a given container.
* Item types are enumerated by TWTY_*

* Container formats, same codes as in TWAIN.H
#DEFINE TWON_ARRAY 3
#DEFINE TWON_ENUMERATION 4
#DEFINE TWON_ONEVALUE 5
#DEFINE TWON_RANGE 6


DECLARE CONTAINER_Free IN Eztwain3.dll ;
   LONG hcon
* Free the memory and resources of a capability container.

DECLARE LONG CONTAINER_Copy IN Eztwain3.dll ;
   LONG hcon
* Create an exact copy of the container.

DECLARE LONG CONTAINER_Equal IN Eztwain3.dll ;
   LONG hconA, ;
   LONG hconB
* Return TRUE (1) iff all properties of hconA and hconB are the same.

DECLARE LONG CONTAINER_Format IN Eztwain3.dll ;
   LONG hcon
* Return the 'format' of this container: TWON_ONEVALUE, etc.

DECLARE LONG CONTAINER_ItemCount IN Eztwain3.dll ;
   LONG hcon
* Return the number of values in the container.
* For a ONEVALUE, return 1.

DECLARE LONG CONTAINER_ItemType IN Eztwain3.dll ;
   LONG hcon
* Return the item type (what exact kind of values are in the container.)
* See the TWTY_* definitions in TWAIN.H

DECLARE LONG CONTAINER_TypeSize IN Eztwain3.dll ;
   LONG nItemType
* Return the size in bytes of an item of the specified type (TWTY_*)

DECLARE CONTAINER_GetStringValue IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n, ;
   STRING @sText
DECLARE DOUBLE CONTAINER_FloatValue IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n
DECLARE LONG CONTAINER_IntValue IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n
DECLARE STRING CONTAINER_StringValue IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n
* Get the value of the nth item in the container.
* n is forced into the range 0 to ItemCount(hcon)-1.
* For string values, if the container items are not strings, they
* are converted to an equivalent string (e.g. "TRUE", "23", "2.37", etc.)


DECLARE LONG CONTAINER_ContainsValue IN Eztwain3.dll ;
   LONG hcon, ;
   DOUBLE d
DECLARE LONG CONTAINER_ContainsValueInt IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n
* Return TRUE(1) if the value is one of the items in the container.
DECLARE LONG CONTAINER_FindValue IN Eztwain3.dll ;
   LONG hcon, ;
   DOUBLE d
DECLARE LONG CONTAINER_FindValueInt IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n
* Return the 0-origin index of the value in the container.
* Return -1 if not found.

DECLARE DOUBLE CONTAINER_CurrentValue IN Eztwain3.dll ;
   LONG hcon
DECLARE DOUBLE CONTAINER_DefaultValue IN Eztwain3.dll ;
   LONG hcon
DECLARE LONG CONTAINER_CurrentValueInt IN Eztwain3.dll ;
   LONG hcon
DECLARE LONG CONTAINER_DefaultValueInt IN Eztwain3.dll ;
   LONG hcon
* Return the container's current or power-up (default) value.
* Array containers do not have these and will return -1.0.
* OneValue containers always return their (one) value.

DECLARE LONG CONTAINER_DefaultIndex IN Eztwain3.dll ;
   LONG hcon
DECLARE LONG CONTAINER_CurrentIndex IN Eztwain3.dll ;
   LONG hcon
* Return the index of the Default or Current value.
* Works on Enumerations, Ranges and OneValues.
* (Always returns 0 for a OneValue)
* Returns -1 for an Array.


DECLARE DOUBLE CONTAINER_MinValue IN Eztwain3.dll ;
   LONG hcon
DECLARE DOUBLE CONTAINER_MaxValue IN Eztwain3.dll ;
   LONG hcon
DECLARE LONG CONTAINER_MinValueInt IN Eztwain3.dll ;
   LONG hcon
DECLARE LONG CONTAINER_MaxValueInt IN Eztwain3.dll ;
   LONG hcon
* Return the smallest/largest value in the container.
* For a OneValue, this is just the value.
* For a Range, these are the Min and Max values of the range.
* For an Array or Enumeration, the container is searched to find
* the smallest/largest value.

DECLARE DOUBLE CONTAINER_StepSize IN Eztwain3.dll ;
   LONG hcon
DECLARE LONG CONTAINER_StepSizeInt IN Eztwain3.dll ;
   LONG hcon
* Return the 'step' value of a Range container.
* Returns -1 if the container is not a Range.

* The following four functions create containers from scratch:
* nItemType is one of the TWTY_* item types from TWAIN.H
* nItems is the number of items, in an array or enumeration.
* dMin, dMax, dStep are the beginning, ending, and step value of a range.
DECLARE LONG CONTAINER_OneValue IN Eztwain3.dll ;
   LONG nItemType, ;
   DOUBLE dVal
DECLARE LONG CONTAINER_Range IN Eztwain3.dll ;
   LONG nItemType, ;
   DOUBLE dMin, ;
   DOUBLE dMax, ;
   DOUBLE dStep
DECLARE LONG CONTAINER_Array IN Eztwain3.dll ;
   LONG nItemType, ;
   LONG nItems
DECLARE LONG CONTAINER_Enumeration IN Eztwain3.dll ;
   LONG nItemType, ;
   LONG nItems

DECLARE LONG CONTAINER_SetItem IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n, ;
   DOUBLE dVal
DECLARE LONG CONTAINER_SetItemInt IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n, ;
   LONG nVal
DECLARE LONG CONTAINER_SetItemString IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n, ;
   STRING sVal
DECLARE LONG CONTAINER_SetItemFrame IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n, ;
   DOUBLE l, ;
   DOUBLE t, ;
   DOUBLE r, ;
   DOUBLE b
DECLARE LONG CONTAINER_GetItemFrame IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n, ;
   DOUBLE @L, ;
   DOUBLE @T, ;
   DOUBLE @R, ;
   DOUBLE @B
* Set(or get) the nth item of the container to dVal or pzText, or frame(l,t,r,b).
* NOTE: A OneValue is treated as an array with 1 element. 
* Return TRUE(1) if successful. FALSE(0) for error such as:
*    The container is not an array, enumeration, or onevalue
*    n < 0 or n >= CONTAINER_ItemCount(hcon)
*    the value cannot be represented in this container's ItemType.
* Frame operations fail if the CONTAINER_ItemType is not TWTY_FRAME.

DECLARE LONG CONTAINER_SelectCurrentValue IN Eztwain3.dll ;
   LONG hcon, ;
   DOUBLE dVal
DECLARE LONG CONTAINER_SelectCurrentItem IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n
* Select the current value within an enumeration or range,
* by specifying either the value, or its index.
* Returns TRUE(1) if successful, FALSE(0) otherwise.
* This will fail if:
*    The container is not an enumeration or range.
*    dVal is not one of the values in the container
*    n < 0 or n >= CONTAINER_ItemCount(hcon)

DECLARE LONG CONTAINER_SelectDefaultValue IN Eztwain3.dll ;
   LONG hcon, ;
   DOUBLE dVal
DECLARE LONG CONTAINER_SelectDefaultItem IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n
* Select the default value in an enumeration or range.
* We're not sure what this would be good for, since an application
* cannot change the default value of a capability - that value is
* determined by the device TWAIN driver.
* So these functions are for logical completeness only.

DECLARE LONG CONTAINER_DeleteItem IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n
* Delete the nth item from an Array or Enumeration container.
* Returns TRUE(1) for success, FALSE(0) otherwise. Failure causes:
*   invalid container handle
*   container is not an array or enumeration
*   n < 0 or n >= ItemCount(hcon)

DECLARE LONG CONTAINER_InsertItem IN Eztwain3.dll ;
   LONG hcon, ;
   LONG n, ;
   DOUBLE dVal
* Insert an item with value dVal into the container at position n.
* If n < 0, the item is inserted at the end of the container.
* Return TRUE(1) on success, FALSE(0) on failure.
* Possible causes of failure:
*   NULL or invalid container handle
*   container format is not enumeration or array
*   memory allocation failed - heap corrupted, or out of memory.

*--- Very low level CONTAINER functions you probably won't need:
DECLARE LONG CONTAINER_Wrap IN Eztwain3.dll ;
   LONG nFormat, ;
   LONG hcon
* Wrap a TWAIN container handle into an HCONTAINER object.
* Note: *Do Not* free the hcon - it is now owned by the HCONTAINER.
DECLARE LONG CONTAINER_Unwrap IN Eztwain3.dll ;
   LONG hcon
* Unwrap a TWAIN container from an HCONTAINER object - free the
* HCONTAINER and return the original TWAIN container handle.
DECLARE LONG CONTAINER_Handle IN Eztwain3.dll ;
   LONG hcon
* Retrieve the handle of the TWAIN container wrapped in our HCONTAINER
DECLARE LONG CONTAINER_IsValid IN Eztwain3.dll ;
   LONG hcon
* Return TRUE if the argument seems to be a valid HCONTAINER object.

*--------- Low-level Capability Negotiation Functions --------

* Setting a capability is valid only in State 4 (TWAIN_SOURCE_OPEN)
* Getting a capability is valid in State 4 or any higher state.

DECLARE LONG TWAIN_IsCapAvailable IN Eztwain3.dll ;
   LONG uCap
* Test if open device responds to a 'Get' on a capability.
* Only valid in State 4 or higher.
* Returns TRUE(1) if the capability can be queried, FALSE(0) if not.

DECLARE LONG TWAIN_Get IN Eztwain3.dll ;
   LONG uCap
* Issue a DAT_CAPABILITY/MSG_GET to the open source.
* Return a capability 'container' - the 'MSG_GET' value of the capability.
* Use CONTAINER_* functions to examine and modify the container object.
* Use CONTAINER_Free to release it when you are done with it.
* A return value of 0 indicates failure:  Call GetConditionCode
* or ReportLastError above.

DECLARE LONG TWAIN_GetDefault IN Eztwain3.dll ;
   LONG uCap
DECLARE LONG TWAIN_GetCurrent IN Eztwain3.dll ;
   LONG uCap
* Issue a DAT_CAPABILITY/MSG_GETDEFAULT or MSG_GETCURRENT.  See Get above.

DECLARE LONG TWAIN_Set IN Eztwain3.dll ;
   LONG uCap, ;
   LONG hcon
* Issue a DAT_CAPABILITY/MSG_SET to the open source,
* using the specified capability and container.
* Return value as for TWAIN_DS

DECLARE LONG TWAIN_Reset IN Eztwain3.dll ;
   LONG uCap
* Issue a MSG_RESET on the specified capability.
* State must be 4.  Returns TRUE(1) if successful, FALSE(0) otherwise.

DECLARE LONG TWAIN_QuerySupport IN Eztwain3.dll ;
   LONG uCap
* Issue a MSG_QUERYSUPPORT on the specified capability.
* State must be 4 or higher.  Returns the integer value that the device
* returned, which can be 0.
* A return < 0 indicates an error.

DECLARE LONG TWAIN_SetCapability IN Eztwain3.dll ;
   LONG cap, ;
   DOUBLE dValue
* The most general capability-setting function, it negotiates
* with the open device to set the given capability to the specified value.
* If successful, returns TRUE(1), otherwise FALSE(0).
* There must be a device open and in state 4, or an error is recorded.
* (See TWAIN_ReportLastError.)

DECLARE LONG TWAIN_SetCapString IN Eztwain3.dll ;
   LONG cap, ;
   STRING sValue
* Set the value of a capability that takes a string value.
* You don't need to specify the 'itemType', EZTwain asks the driver
* which itemType it wants.

DECLARE LONG TWAIN_SetCapBool IN Eztwain3.dll ;
   LONG cap, ;
   LONG bValue
* Shorthand for TWAIN_SetCapOneValue(cap, TWTY_BOOL, bValue);

DECLARE LONG TWAIN_GetCapBool IN Eztwain3.dll ;
   LONG cap, ;
   LONG bDefault
DECLARE DOUBLE TWAIN_GetCapFix32 IN Eztwain3.dll ;
   LONG cap, ;
   DOUBLE dDefault
DECLARE LONG TWAIN_GetCapUint16 IN Eztwain3.dll ;
   LONG cap, ;
   LONG nDefault
DECLARE LONG TWAIN_GetCapUint32 IN Eztwain3.dll ;
   LONG cap, ;
   LONG lDefault
* Issue a DAT_CAPABILITY/MSG_GETCURRENT on the specified capability,
* assuming the value type is Bool, Fix32, etc..
* If successful, return the returned value.  Otherwise return bDefault.
* This is only valid in State 4 (TWAIN_SOURCE_OPEN) or higher.

DECLARE LONG TWAIN_SetCapFix32 IN Eztwain3.dll ;
   LONG Cap, ;
   DOUBLE dVal
DECLARE LONG TWAIN_SetCapOneValue IN Eztwain3.dll ;
   LONG Cap, ;
   LONG ItemType, ;
   LONG ItemVal
* Do a DAT_CAPABILITY/MSG_SET, on capability 'Cap' (e.g. ICAP_PIXELTYPE,
* CAP_AUTOFEED, etc.) using a TW_ONEVALUE container with the given item type
* and value.  Use SetCapFix32 for capabilities that take a FIX32 value,
* use SetCapOneValue for the various ints and uints.  These functions
* do not support FRAME or STR items.
* Return Value: TRUE (1) if successful, FALSE (0) otherwise.

DECLARE LONG TWAIN_SetCapFix32R IN Eztwain3.dll ;
   LONG Cap, ;
   LONG Numerator, ;
   LONG Denominator
* Just like TWAIN_SetCapFix32, but uses the value Numerator/Denominator
* This is useful for languages that make it hard to pass double parameters.

DECLARE LONG TWAIN_GetCapCurrent IN Eztwain3.dll ;
   LONG Cap, ;
   LONG ItemType, ;
   STRING @pVal
* Do a DAT_CAPABILITY/MSG_GETCURRENT on capability 'Cap'.
* Copy the current value out of the returned container into *pVal.
* If the operation fails (the source refuses the request), or if the
* container is not a ONEVALUE or ENUMERATION, or if the item type of the
* returned container is incompatible with the expected TWTY_ type in nType,
* returns FALSE.  If this function returns FALSE, *pVal is not touched.

DECLARE LONG TWAIN_ToFix32 IN Eztwain3.dll ;
   DOUBLE d
* Convert a floating-point value to a 32-bit TW_FIX32 value that can be passed
* to e.g. TWAIN_SetCapOneValue
DECLARE LONG TWAIN_ToFix32R IN Eztwain3.dll ;
   LONG Numerator, ;
   LONG Denominator
* Convert a rational number to a 32-bit TW_FIX32 value.
* Returns a TW_FIX32 value that approximates Numerator/Denominator

DECLARE DOUBLE TWAIN_Fix32ToFloat IN Eztwain3.dll ;
   LONG nfix
* Convert a TW_FIX32 value (as returned from some capability inquiries)
* to a double (floating point) value.


*--------- Custom DS Data
*
* The following functions support the relatively exotic CUSTOMDSDATA feature
* introduced in TWAIN 1.7.  This feature, if supported by a device, allows
* the application to read and set, all the settings of the device
* simultaneously with one block of data.  *The format of the data is defined
* by each device* and is undocumented.  So this is just a way to capture
* a snapshot of a particular device's settings, and then to
* restore that state at a later time.
*
* To find out if a device supports this feature, open the device and see if
* TWAIN_GetCapBool(CAP_CUSTOMDSDATA, FALSE) returns TRUE.
*
* The TWAIN_State() must be 4 or these functions will display an error.
*
DECLARE LONG TWAIN_GetCustomDataToFile IN Eztwain3.dll ;
   STRING sFilename
DECLARE LONG TWAIN_SetCustomDataFromFile IN Eztwain3.dll ;
   STRING sFilename
* Both functions return TRUE(1) if successful, FALSE(0) otherwise.
* These functions will display an error message if called outside State 4.
* In case of failure, call LastErrorCode, ReportLastError, etc. for details.
* No file extension is assumed, you should provide one, such as ".dat".

*--------- Extended Image Info
*
* The following functions support the 'Extended Image Info' feature of TWAIN,
* which is implemented by only a few TWAIN drivers.  This consists of special
* information, sometimes called 'metadata' which can be collected about
* each scanned image, in addition to the image itself.
* Examples of extended image info include
* TWEI_BARCODETEXT - text of a barcode found in the scan
* TWEI_SKEWORIGINALANGLE - the amount of 'skew' in the original raw scan
* See the TWAIN Specification (version 1.9 or later) for details.

DECLARE LONG TWAIN_IsExtendedInfoSupported IN Eztwain3.dll
* Asks the currently open device if it supports Extended Image Info.
* Returns TRUE(1) if yes, FALSE(0) if not.

DECLARE LONG TWAIN_EnableExtendedInfo IN Eztwain3.dll ;
   LONG eiCode, ;
   LONG enabled
* Enable or disable collection of a particular kind of extended image info.
* Each type of information is represented by an integer constant with
* prefix TWEI_ see the list of constants elsewhere in this file.
* There is a limit to how many different info types can be enabled at the
* same time.  If this limit is exceeded, this function returns FALSE
* and has no effect.  Otherwise (if successful) it returns TRUE.

DECLARE LONG TWAIN_IsExtendedInfoEnabled IN Eztwain3.dll ;
   LONG eiCode
* Return TRUE if the specified extended image type is enabled
* (for collection)

DECLARE TWAIN_DisableExtendedInfo IN Eztwain3.dll
* Disables all extended image info - none is collected after this.

* After a successful scan, you can use the following functions to
* retrieve the extended image info associated with that scan:
DECLARE LONG TWAIN_ExtendedInfoItemCount IN Eztwain3.dll ;
   LONG eiCode
* Return the number of items of data available of the given info type.

DECLARE LONG TWAIN_ExtendedInfoItemType IN Eztwain3.dll ;
   LONG eiCode
* Return a number indicating the type of data returned for the specified extended info.
* Returns the same TWTY_ codes as CONTAINER_ItemType.

DECLARE LONG TWAIN_ExtendedInfoInt IN Eztwain3.dll ;
   LONG eiCode, ;
   LONG n
* Return the (integer) value of the 'nth' item of the specified extended info.

DECLARE DOUBLE TWAIN_ExtendedInfoFloat IN Eztwain3.dll ;
   LONG eiCode, ;
   LONG n
* Return the (floating point) value of the 'nth' item of the specified extended info.

DECLARE LONG TWAIN_GetExtendedInfoString IN Eztwain3.dll ;
   LONG eiCode, ;
   LONG n, ;
   STRING @Buffer, ;
   LONG Bufsize
* Read the (string) value of the nth item of the specified info type into Buffer,
* which has been allocated by the caller to hold Bufsize characters.
* Note that the value returned is ASCII (byte) text, not unicode, and *always*
* includes an ending 0 byte, even if it must be truncated to fit.
* Returns TRUE if the data was retrieved and could fit in the buffer.
* Returns FALSE otherwise.

DECLARE STRING TWAIN_ExtendedInfoString IN Eztwain3.dll ;
   LONG eiCode, ;
   LONG n
* As above, but the string is returned as a temporary pointer to a
* 0-terminated ASCII string.
* In case of any failure, returns the empty string ("").

DECLARE LONG TWAIN_GetExtendedInfoFrame IN Eztwain3.dll ;
   LONG eiCode, ;
   LONG n, ;
   DOUBLE @L, ;
   DOUBLE @T, ;
   DOUBLE @R, ;
   DOUBLE @B
* Fetch the TW_FRAME value of the 'nth' item of the specified extended info.
* This is rarely used, but is here for completeness.

* Extended Image Info codes
#DEFINE TWEI_MIN 4608

#DEFINE TWEI_BARCODEX 4608
#DEFINE TWEI_BARCODEY 4609
#DEFINE TWEI_BARCODETEXT 4610
#DEFINE TWEI_BARCODETYPE 4611
#DEFINE TWEI_DESHADETOP 4612
#DEFINE TWEI_DESHADELEFT 4613
#DEFINE TWEI_DESHADEHEIGHT 4614
#DEFINE TWEI_DESHADEWIDTH 4615
#DEFINE TWEI_DESHADESIZE 4616
#DEFINE TWEI_SPECKLESREMOVED 4617
#DEFINE TWEI_HORZLINEXCOORD 4618
#DEFINE TWEI_HORZLINEYCOORD 4619
#DEFINE TWEI_HORZLINELENGTH 4620
#DEFINE TWEI_HORZLINETHICKNESS 4621
#DEFINE TWEI_VERTLINEXCOORD 4622
#DEFINE TWEI_VERTLINEYCOORD 4623
#DEFINE TWEI_VERTLINELENGTH 4624
#DEFINE TWEI_VERTLINETHICKNESS 4625
#DEFINE TWEI_PATCHCODE 4626
#DEFINE TWEI_ENDORSEDTEXT 4627
#DEFINE TWEI_FORMCONFIDENCE 4628
#DEFINE TWEI_FORMTEMPLATEMATCH 4629
#DEFINE TWEI_FORMTEMPLATEPAGEMATCH 4630
#DEFINE TWEI_FORMHORZDOCOFFSET 4631
#DEFINE TWEI_FORMVERTDOCOFFSET 4632
#DEFINE TWEI_BARCODECOUNT 4633
#DEFINE TWEI_BARCODECONFIDENCE 4634
#DEFINE TWEI_BARCODEROTATION 4635
#DEFINE TWEI_BARCODETEXTLENGTH 4636
#DEFINE TWEI_DESHADECOUNT 4637
#DEFINE TWEI_DESHADEBLACKCOUNTOLD 4638
#DEFINE TWEI_DESHADEBLACKCOUNTNEW 4639
#DEFINE TWEI_DESHADEBLACKRLMIN 4640
#DEFINE TWEI_DESHADEBLACKRLMAX 4641
#DEFINE TWEI_DESHADEWHITECOUNTOLD 4642
#DEFINE TWEI_DESHADEWHITECOUNTNEW 4643
#DEFINE TWEI_DESHADEWHITERLMIN 4644
#DEFINE TWEI_DESHADEWHITERLAVE 4645
#DEFINE TWEI_DESHADEWHITERLMAX 4646
#DEFINE TWEI_BLACKSPECKLESREMOVED 4647
#DEFINE TWEI_WHITESPECKLESREMOVED 4648
#DEFINE TWEI_HORZLINECOUNT 4649
#DEFINE TWEI_VERTLINECOUNT 4650
#DEFINE TWEI_DESKEWSTATUS 4651
#DEFINE TWEI_SKEWORIGINALANGLE 4652
#DEFINE TWEI_SKEWFINALANGLE 4653
#DEFINE TWEI_SKEWCONFIDENCE 4654
#DEFINE TWEI_SKEWWINDOWX1 4655
#DEFINE TWEI_SKEWWINDOWY1 4656
#DEFINE TWEI_SKEWWINDOWX2 4657
#DEFINE TWEI_SKEWWINDOWY2 4658
#DEFINE TWEI_SKEWWINDOWX3 4659
#DEFINE TWEI_SKEWWINDOWY3 4660
#DEFINE TWEI_SKEWWINDOWX4 4661
#DEFINE TWEI_SKEWWINDOWY4 4662
#DEFINE TWEI_BOOKNAME 4664
#DEFINE TWEI_CHAPTERNUMBER 4665
#DEFINE TWEI_DOCUMENTNUMBER 4666
#DEFINE TWEI_PAGENUMBER 4667
#DEFINE TWEI_CAMERA 4668
#DEFINE TWEI_FRAMENUMBER 4669
#DEFINE TWEI_FRAME 4670
#DEFINE TWEI_PIXELFLAVOR 4671
#DEFINE TWEI_ICCPROFILE 4672
#DEFINE TWEI_LASTSEGMENT 4673
#DEFINE TWEI_SEGMENTNUMBER 4674
#DEFINE TWEI_MAGDATA 4675
#DEFINE TWEI_MAGTYPE 4676
#DEFINE TWEI_PAGESIDE 4677
#DEFINE TWEI_FILESYSTEMSOURCE 4678

#DEFINE TWEI_MAX 4678


*--------- Lowest-level functions for TWAIN protocol --------


DECLARE LONG TWAIN_DS IN Eztwain3.dll ;
   LONG DG, ;
   LONG DAT, ;
   LONG MSG, ;
   STRING @pData
* Pass the triplet (DG, DAT, MSG, pData) to the open data source if any.
* Returns TRUE(1) if the result code is TWRC_SUCCESS, FALSE(0) otherwise.
* The last result code can be retrieved with TWAIN_GetResultCode(), and the
* corresponding condition code can be retrieved with TWAIN_GetConditionCode().
* If no source is open this call will fail, result code TWRC_FAILURE,
* condition code TWCC_NODS.

DECLARE LONG TWAIN_Mgr IN Eztwain3.dll ;
   LONG DG, ;
   LONG DAT, ;
   LONG MSG, ;
   STRING @pData
* Pass a triplet to the Data Source Manager (DSM).
* Returns TRUE(1) for success, FALSE(0) otherwise.
* See GetResultCode, GetConditionCode, and ReportLastError functions
* for diagnosing and reporting a TWAIN_Mgr failure.
* If the Source Manager is not open, this call fails setting result code
* TWRC_FAILURE, and condition code=TWCC_SEQERROR (triplet out of sequence).


*--------- Advanced / Exotic --------

DECLARE LONG TWAIN_SetImageReadyTimeout IN Eztwain3.dll ;
   LONG nSec
* Set the maximum seconds to wait for an image-ready notification,
* (when one is expected i.e. after an enable) before posting a
* dialog that says 'Waiting for <device>' - with a Cancel button.
* Returns the previous setting.
* ** Default is -1 which disables this feature.
* With certain scanners there is a long delay between when the scanner
* is enabled and when it says "ready to scan".  Also, we have found
* a few scanners that intermittently fail to send "ready to scan" - by
* setting this timeout, you give your users a way to recover from
* this failure (otherwise the application has to be forcibly terminated.)

DECLARE TWAIN_AutoClickButton IN Eztwain3.dll ;
   STRING sButtonName
* Calling this function before scanning tells EZTwain to attempt to
* automatically press a button when the device dialog appears.
* If you pass a null button name, EZTwain tries a number
* of likely choices (in English) including:
* "Scan" "Capture" "Acquire" "Scan Now" "Start Scan"  "Start Scanning"
* Case is ignored in the comparison ("SCAN" and "scan" are equivalent.)
* This function is useful when you want to automate operation of
* a device that insists on showing its user interface. 

DECLARE TWAIN_BreakModalLoop IN Eztwain3.dll
* Expert: If EZTwain is hung inside an Acquire or GetMessage loop waiting for
* something to happen, this function will break the loop, as if the pending
* transfer had failed.  TWAIN_State() will be valid, and you will need to
* call appropriate functions to transition TWAIN as desired.

DECLARE TWAIN_EmptyMessageQueue IN Eztwain3.dll
* Expert: Get and process any pending Windows messages for this thread.
* For example, keystrokes or mouse clicks.  Calling this during
* long processes will allow the user to interact with the UI.
* Use only if you understand the message pump.

*--------- Dosadi Special --------

DECLARE STRING TWAIN_BuildName IN Eztwain3.dll
* Return a string describing the build of EZTWAIN e.g. "Release - Build 6"

DECLARE TWAIN_GetBuildName IN Eztwain3.dll ;
   STRING @sName
* Like TWAIN_BuildName, but copies the build string into its parameter.
* The parameter is a string variable (char array in C/C++).
* You are responsible for allocating room for 128 8-bit characters
* in the string variable before calling this function.

DECLARE LONG TWAIN_GetSourceIdentity IN Eztwain3.dll ;
   STRING @ptwid

DECLARE LONG TWAIN_GetImageInfo IN Eztwain3.dll ;
   STRING @ptwinfo
* Issue a DG_IMAGE / DAT_IMAGEINFO / MSG_GET placing the returned data
* at ptwinfo.  The returned structure is a TW_IMAGEINFO - see twain.h.

DECLARE TWAIN_LogFile IN Eztwain3.dll ;
   LONG fLog
* Turn logging eztwain.log on or off.
* By default the log file is written to C:\ but this
* can be overridden, see TWAIN_SetLogFolder below.
*
* fLog = 0    close log file and turn off logging
* The following flags can be combined to enable logging:
* 1            basic logging of TWAIN and EZTwain operations.
* 2            flush log constantly (use if EZTwain crashes)
* 4            log Windows messages flowing through EZTwain
#DEFINE EZT_LOG_ON 1
#DEFINE EZT_LOG_FLUSH 2
#DEFINE EZT_LOG_DETAIL 4


DECLARE LONG TWAIN_SetLogFolder IN Eztwain3.dll ;
   STRING sFolder
* Specify the folder (directory) where the log file
* should be placed.  Default is "c:\" - the root of the C: drive.
* EZTwain appends a trailing 'slash' if needed.
* Passing NULL or "" resets to the default: "c:\"
*
* If the file cannot be created in this folder, EZTwain tries
* to create it in the Windows temp folder - this varies somewhat
* by Windows version, search for the Windows API call GetTempPath.

DECLARE LONG TWAIN_SetLogName IN Eztwain3.dll ;
   STRING sName
* Set the filename or path & filename of the EZTwain log file.
* If there is a log file open, it is closed, renamed & re-opened.
* The default extension is ".log".
* The default log filename is "eztwain.log".
*
* You can specify a fully-qualified filename, which changes
* both the folder and filename for logging:
* TWAIN_SetLogName("c:\temp\scan2tape.log")

DECLARE STRING TWAIN_LogFileName IN Eztwain3.dll
* Return the (fully qualified) file path and name for logging.

DECLARE TWAIN_WriteToLog IN Eztwain3.dll ;
   STRING sText
* Write text to the EZTwain log file (c:\eztwain.log)
* If the text does not end with a newline, one is supplied.
* If logging is turned off, this call has no effect.
* Logging is controlled by TWAIN_LogFile - see above.


DECLARE LONG TWAIN_SelfTest IN Eztwain3.dll ;
   LONG f
* Perform internal self-test.
*   f      ignored for now
* Return value:
*   0      success
*   other  internal test failed.

DECLARE LONG TWAIN_Blocked IN Eztwain3.dll
* Returns TRUE(1) if processing is inside TWAIN (Source Manager or a DS)
* FALSE(0) otherwise.  If the former, making any TWAIN call will
* fail immediately or deadlock the application (Not recommended.)


* Deprecated - still work, don't use in new code.
DECLARE TWAIN_FreeNative IN Eztwain3.dll ;
   LONG hdib
* superceded by DIB_Free.

DECLARE LONG TWAIN_NegotiatePixelTypes IN Eztwain3.dll ;
   LONG wPixTypes
DECLARE LONG TWAIN_AcquireNative IN Eztwain3.dll ;
   LONG hwndApp, ;
   LONG wPixTypes
#DEFINE TWAIN_BW 1
#DEFINE TWAIN_GRAY 2
#DEFINE TWAIN_RGB 4
#DEFINE TWAIN_PALETTE 8
#DEFINE TWAIN_CMY 16
#DEFINE TWAIN_CMYK 32

#DEFINE TWAIN_ANYTYPE 0

DECLARE LONG TWAIN_AcquireToClipboard IN Eztwain3.dll ;
   LONG hwndApp, ;
   LONG wPixTypes
* Like AcquireNative, but puts the resulting image, if any, into the
* system clipboard as a CF_DIB item. If this call fails, the clipboard is
* either empty or retains its previous content.
* Returns TRUE(1) for success, FALSE(0) for failure.
*
* Useful for environments like Visual Basic where it is hard to make direct
* use of a DIB handle.  In fact, TWAIN_AcquireToClipboard uses
* TWAIN_AcquireNative for all the hard work.



* From twain.h:
*****************************************************************************
** Capabilities                                                             *
*****************************************************************************

#DEFINE CAP_CUSTOMBASE 32768

* all data sources are REQUIRED to support these caps 
#DEFINE CAP_XFERCOUNT 1

* image data sources are REQUIRED to support these caps 
#DEFINE ICAP_COMPRESSION 256
#DEFINE ICAP_PIXELTYPE 257
#DEFINE ICAP_UNITS 258
#DEFINE ICAP_XFERMECH 259

* all data sources MAY support these caps 
#DEFINE CAP_AUTHOR 4096
#DEFINE CAP_CAPTION 4097
#DEFINE CAP_FEEDERENABLED 4098
#DEFINE CAP_FEEDERLOADED 4099
#DEFINE CAP_TIMEDATE 4100
#DEFINE CAP_SUPPORTEDCAPS 4101
#DEFINE CAP_EXTENDEDCAPS 4102
#DEFINE CAP_AUTOFEED 4103
#DEFINE CAP_CLEARPAGE 4104
#DEFINE CAP_FEEDPAGE 4105
#DEFINE CAP_REWINDPAGE 4106
#DEFINE CAP_INDICATORS 4107
#DEFINE CAP_SUPPORTEDCAPSEXT 4108
#DEFINE CAP_PAPERDETECTABLE 4109
#DEFINE CAP_UICONTROLLABLE 4110
#DEFINE CAP_DEVICEONLINE 4111
#DEFINE CAP_AUTOSCAN 4112
#DEFINE CAP_THUMBNAILSENABLED 4113
#DEFINE CAP_DUPLEX 4114
#DEFINE CAP_DUPLEXENABLED 4115
#DEFINE CAP_ENABLEDSUIONLY 4116
#DEFINE CAP_CUSTOMDSDATA 4117
#DEFINE CAP_ENDORSER 4118
#DEFINE CAP_JOBCONTROL 4119
#DEFINE CAP_ALARMS 4120
#DEFINE CAP_ALARMVOLUME 4121
#DEFINE CAP_AUTOMATICCAPTURE 4122
#DEFINE CAP_TIMEBEFOREFIRSTCAPTURE 4123
#DEFINE CAP_TIMEBETWEENCAPTURES 4124
#DEFINE CAP_CLEARBUFFERS 4125
#DEFINE CAP_MAXBATCHBUFFERS 4126
#DEFINE CAP_DEVICETIMEDATE 4127
#DEFINE CAP_POWERSUPPLY 4128
#DEFINE CAP_CAMERAPREVIEWUI 4129
#DEFINE CAP_DEVICEEVENT 4130
#DEFINE CAP_SERIALNUMBER 4132
#DEFINE CAP_PRINTER 4134
#DEFINE CAP_PRINTERENABLED 4135
#DEFINE CAP_PRINTERINDEX 4136
#DEFINE CAP_PRINTERMODE 4137
#DEFINE CAP_PRINTERSTRING 4138
#DEFINE CAP_PRINTERSUFFIX 4139
#DEFINE CAP_LANGUAGE 4140
#DEFINE CAP_FEEDERALIGNMENT 4141
#DEFINE CAP_FEEDERORDER 4142
#DEFINE CAP_REACQUIREALLOWED 4144
#DEFINE CAP_BATTERYMINUTES 4146
#DEFINE CAP_BATTERYPERCENTAGE 4147

* image data sources MAY support these caps 
#DEFINE ICAP_AUTOBRIGHT 4352
#DEFINE ICAP_BRIGHTNESS 4353
#DEFINE ICAP_CONTRAST 4355
#DEFINE ICAP_CUSTHALFTONE 4356
#DEFINE ICAP_EXPOSURETIME 4357
#DEFINE ICAP_FILTER 4358
#DEFINE ICAP_FLASHUSED 4359
#DEFINE ICAP_GAMMA 4360
#DEFINE ICAP_HALFTONES 4361
#DEFINE ICAP_HIGHLIGHT 4362
#DEFINE ICAP_IMAGEFILEFORMAT 4364
#DEFINE ICAP_LAMPSTATE 4365
#DEFINE ICAP_LIGHTSOURCE 4366
#DEFINE ICAP_ORIENTATION 4368
#DEFINE ICAP_PHYSICALWIDTH 4369
#DEFINE ICAP_PHYSICALHEIGHT 4370
#DEFINE ICAP_SHADOW 4371
#DEFINE ICAP_FRAMES 4372
#DEFINE ICAP_XNATIVERESOLUTION 4374
#DEFINE ICAP_YNATIVERESOLUTION 4375
#DEFINE ICAP_XRESOLUTION 4376
#DEFINE ICAP_YRESOLUTION 4377
#DEFINE ICAP_MAXFRAMES 4378
#DEFINE ICAP_TILES 4379
#DEFINE ICAP_BITORDER 4380
#DEFINE ICAP_CCITTKFACTOR 4381
#DEFINE ICAP_LIGHTPATH 4382
#DEFINE ICAP_PIXELFLAVOR 4383
#DEFINE ICAP_PLANARCHUNKY 4384
#DEFINE ICAP_ROTATION 4385
#DEFINE ICAP_SUPPORTEDSIZES 4386
#DEFINE ICAP_THRESHOLD 4387
#DEFINE ICAP_XSCALING 4388
#DEFINE ICAP_YSCALING 4389
#DEFINE ICAP_BITORDERCODES 4390
#DEFINE ICAP_PIXELFLAVORCODES 4391
#DEFINE ICAP_JPEGPIXELTYPE 4392
#DEFINE ICAP_TIMEFILL 4394
#DEFINE ICAP_BITDEPTH 4395
#DEFINE ICAP_BITDEPTHREDUCTION 4396
#DEFINE ICAP_UNDEFINEDIMAGESIZE 4397
#DEFINE ICAP_IMAGEDATASET 4398
#DEFINE ICAP_EXTIMAGEINFO 4399
#DEFINE ICAP_MINIMUMHEIGHT 4400
#DEFINE ICAP_MINIMUMWIDTH 4401
#DEFINE ICAP_FLIPROTATION 4406
#DEFINE ICAP_BARCODEDETECTIONENABLED 4407
#DEFINE ICAP_SUPPORTEDBARCODETYPES 4408
#DEFINE ICAP_BARCODEMAXSEARCHPRIORITIES 4409
#DEFINE ICAP_BARCODESEARCHPRIORITIES 4410
#DEFINE ICAP_BARCODESEARCHMODE 4411
#DEFINE ICAP_BARCODEMAXRETRIES 4412
#DEFINE ICAP_BARCODETIMEOUT 4413
#DEFINE ICAP_ZOOMFACTOR 4414
#DEFINE ICAP_PATCHCODEDETECTIONENABLED 4415
#DEFINE ICAP_SUPPORTEDPATCHCODETYPES 4416
#DEFINE ICAP_PATCHCODEMAXSEARCHPRIORITIES 4417
#DEFINE ICAP_PATCHCODESEARCHPRIORITIES 4418
#DEFINE ICAP_PATCHCODESEARCHMODE 4419
#DEFINE ICAP_PATCHCODEMAXRETRIES 4420
#DEFINE ICAP_PATCHCODETIMEOUT 4421
#DEFINE ICAP_FLASHUSED2 4422
#DEFINE ICAP_IMAGEFILTER 4423
#DEFINE ICAP_NOISEFILTER 4424
#DEFINE ICAP_OVERSCAN 4425
#DEFINE ICAP_AUTOMATICBORDERDETECTION 4432
#DEFINE ICAP_AUTOMATICDESKEW 4433
#DEFINE ICAP_AUTOMATICROTATE 4434
#DEFINE ICAP_JPEGQUALITY 4435

* Container and Extended Info item types:
#DEFINE TWTY_INT8 0
#DEFINE TWTY_INT16 1
#DEFINE TWTY_INT32 2
#DEFINE TWTY_UINT8 3
#DEFINE TWTY_UINT16 4
#DEFINE TWTY_UINT32 5
#DEFINE TWTY_BOOL 6
#DEFINE TWTY_FIX32 7
#DEFINE TWTY_FRAME 8
#DEFINE TWTY_STR32 9
#DEFINE TWTY_STR64 10
#DEFINE TWTY_STR128 11
#DEFINE TWTY_STR255 12
#DEFINE TWTY_STR1024 13
#DEFINE TWTY_UNI512 14

* ICAP_ORIENTATION values (OR_ means ORientation) 
#DEFINE TWOR_ROT0 0
#DEFINE TWOR_ROT90 1
#DEFINE TWOR_ROT180 2
#DEFINE TWOR_ROT270 3



* EZTwain History: See History.txt
