﻿// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'GLPerlin.pas' rev: 35.00 (Windows)

#ifndef GlperlinHPP
#define GlperlinHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <System.Math.hpp>
#include <Vcl.Graphics.hpp>
#include <GLVectorGeometry.hpp>
#include <GLPerlinBase.hpp>
#include <GLHeightData.hpp>

//-- user supplied -----------------------------------------------------------

namespace Glperlin
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGLBasePerlinOctav;
class DELPHICLASS TGLBasePerlin;
class DELPHICLASS TGL1DPerlin;
class DELPHICLASS TGL2DPerlinOctav;
class DELPHICLASS TGL2DPerlin;
class DELPHICLASS TGLPerlinHDS;
class DELPHICLASS TGLPerlinHDSThread;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TGLPerlinInterpolation : unsigned char { pi_none, pi_simple, pi_linear, pi_Smoothed, pi_Cosine, pi_cubic };

class PASCALIMPLEMENTATION TGLBasePerlinOctav : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	double FAmplitude;
	double FScale;
	TGLPerlinInterpolation FInterpolation;
	TGLPerlinInterpolation FSmoothing;
	
public:
	virtual void __fastcall Generate() = 0 ;
	__property TGLPerlinInterpolation Interpolation = {read=FInterpolation, write=FInterpolation, nodefault};
	__property TGLPerlinInterpolation Smoothing = {read=FSmoothing, write=FSmoothing, nodefault};
	__property double Amplitude = {read=FAmplitude, write=FAmplitude};
	__property double Scale = {read=FScale, write=FScale};
public:
	/* TObject.Create */ inline __fastcall TGLBasePerlinOctav() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGLBasePerlinOctav() { }
	
};


typedef System::TMetaClass* TGLPerlinOctav;

class PASCALIMPLEMENTATION TGLBasePerlin : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	double FPersistence;
	int FNumber_Of_Octaves;
	System::Classes::TList* FOctaves;
	TGLPerlinOctav FOctavClass;
	TGLPerlinInterpolation FInterpolation;
	TGLPerlinInterpolation FSmoothing;
	
protected:
	double __fastcall PerlinNoise_1D(double x);
	double __fastcall PerlinNoise_2D(double x, double y);
	TGLBasePerlinOctav* __fastcall GetOctave(int index);
	void __fastcall SetPersistence(double val);
	void __fastcall Set_Number_Of_Octaves(int val);
	
public:
	__fastcall virtual TGLBasePerlin(System::Classes::TComponent* AOwner);
	virtual void __fastcall Generate() = 0 ;
	__property TGLBasePerlinOctav* Octaves[int index] = {read=GetOctave};
	
__published:
	__property TGLPerlinInterpolation Smoothing = {read=FSmoothing, write=FSmoothing, nodefault};
	__property TGLPerlinInterpolation Interpolation = {read=FInterpolation, write=FInterpolation, nodefault};
	__property double Persistence = {read=FPersistence, write=SetPersistence};
	__property int Number_Of_Octaves = {read=FNumber_Of_Octaves, write=Set_Number_Of_Octaves, nodefault};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TGLBasePerlin() { }
	
};


class PASCALIMPLEMENTATION TGL1DPerlin : public TGLBasePerlin
{
	typedef TGLBasePerlin inherited;
	
__published:
	double __fastcall GetPerlinValue_1D(double x);
public:
	/* TGLBasePerlin.Create */ inline __fastcall virtual TGL1DPerlin(System::Classes::TComponent* AOwner) : TGLBasePerlin(AOwner) { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TGL1DPerlin() { }
	
};


class PASCALIMPLEMENTATION TGL2DPerlinOctav : public TGLBasePerlinOctav
{
	typedef TGLBasePerlinOctav inherited;
	
public:
	Glperlinbase::T2DPerlinArray Data;
	int Width;
	int Height;
	int XStart;
	int YStart;
	int XStep;
	int YStep;
	int YRate;
	virtual void __fastcall Generate();
	double __fastcall GetDataSmoothed(int x, int y);
	double __fastcall GetData(int x, int y);
	double __fastcall GetCubic(double x, double y);
	double __fastcall GetCosine(double x, double y);
	double __fastcall GetPerling(double x, double y);
	void __fastcall Generate_CubicInterpolate();
	void __fastcall Generate_SmoothInterpolate();
	void __fastcall Generate_NonInterpolated();
public:
	/* TObject.Create */ inline __fastcall TGL2DPerlinOctav() : TGLBasePerlinOctav() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGL2DPerlinOctav() { }
	
};


class PASCALIMPLEMENTATION TGL2DPerlin : public TGLBasePerlin
{
	typedef TGLBasePerlin inherited;
	
public:
	int Width;
	int Height;
	int XStart;
	int YStart;
	int XStep;
	int YStep;
	double MaxValue;
	double MinValue;
	__fastcall virtual TGL2DPerlin(System::Classes::TComponent* AOwner);
	virtual void __fastcall Generate();
	double __fastcall GetPerlinValue_2D(double x, double y);
	void __fastcall MakeBitmap(Vcl::Graphics::TBitmap* Param);
	void __fastcall SetHeightData(Glheightdata::TGLHeightData* heightData);
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TGL2DPerlin() { }
	
};


class PASCALIMPLEMENTATION TGLPerlinHDS : public Glheightdata::TGLHeightDataSource
{
	typedef Glheightdata::TGLHeightDataSource inherited;
	
private:
	TGLPerlinInterpolation FInterpolation;
	TGLPerlinInterpolation FSmoothing;
	double FPersistence;
	int FNumber_Of_Octaves;
	System::Classes::TStrings* FLines;
	bool FLinesChanged;
	int FXStart;
	int FYStart;
	
public:
	double MaxValue;
	double MinValue;
	bool Stall;
	__fastcall virtual TGLPerlinHDS(System::Classes::TComponent* AOwner);
	virtual void __fastcall StartPreparingData(Glheightdata::TGLHeightData* heightData);
	void __fastcall WaitFor();
	__property System::Classes::TStrings* Lines = {read=FLines};
	__property bool LinesChanged = {read=FLinesChanged, write=FLinesChanged, nodefault};
	
__published:
	__property TGLPerlinInterpolation Interpolation = {read=FInterpolation, write=FInterpolation, nodefault};
	__property TGLPerlinInterpolation Smoothing = {read=FSmoothing, write=FSmoothing, nodefault};
	__property double Persistence = {read=FPersistence, write=FPersistence};
	__property int Number_Of_Octaves = {read=FNumber_Of_Octaves, write=FNumber_Of_Octaves, nodefault};
	__property MaxPoolSize;
	__property int XStart = {read=FXStart, write=FXStart, nodefault};
	__property int YStart = {read=FYStart, write=FYStart, nodefault};
public:
	/* TGLHeightDataSource.Destroy */ inline __fastcall virtual ~TGLPerlinHDS() { }
	
};


class PASCALIMPLEMENTATION TGLPerlinHDSThread : public Glheightdata::TGLHeightDataThread
{
	typedef Glheightdata::TGLHeightDataThread inherited;
	
public:
	TGL2DPerlin* Perlin;
	TGLPerlinHDS* PerlinSource;
	void __fastcall OpdateOutSide();
	virtual void __fastcall Execute();
public:
	/* TGLHeightDataThread.Destroy */ inline __fastcall virtual ~TGLPerlinHDSThread() { }
	
public:
	/* TThread.Create */ inline __fastcall TGLPerlinHDSThread()/* overload */ : Glheightdata::TGLHeightDataThread() { }
	/* TThread.Create */ inline __fastcall TGLPerlinHDSThread(bool CreateSuspended)/* overload */ : Glheightdata::TGLHeightDataThread(CreateSuspended) { }
	/* TThread.Create */ inline __fastcall TGLPerlinHDSThread(bool CreateSuspended, NativeUInt ReservedStackSize)/* overload */ : Glheightdata::TGLHeightDataThread(CreateSuspended, ReservedStackSize) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Glperlin */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_GLPERLIN)
using namespace Glperlin;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// GlperlinHPP