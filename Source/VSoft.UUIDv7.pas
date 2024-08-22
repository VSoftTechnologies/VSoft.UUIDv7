unit VSoft.UUIDv7;

interface

type
  TUUIDV7Helper = record
    class function CreateV7 : TGuid;overload;static;
    class function CreateV7(const dt : TDateTime) : TGuid;overload;static;
    class function CreatedUTC(const guid : TGUID) : TDateTime;static;
    class function IsV7(const guid : TGuid) : boolean;static;inline;
    class function Version(const guid : TGuid) : integer;static;inline;
  end;


implementation

uses
  {$IFDEF MSWINDOWS}
  WinApi.Windows,
  {$ENDIF}
  System.DateUtils,
  System.SysUtils;



{$IFDEF MSWINDOWS}
//This is substantially faster.
function UNIXTimeInMilliseconds: UInt64;inline;
const
  TimeOffset = 116444736000000000;
var
  ft: TFileTime;
begin
  GetSystemTimeAsFileTime(ft);
  result := (UInt64(ft) - UInt64(TimeOffset)) div 10000;
end;
{$ELSE}
//TODO : find an implementation of this for non windows platforms in earlier versions
// NowUtc only available in 11.3 or later.
// this is slow.
function UNIXTimeInMilliseconds: UInt64;inline;
var
  DT: TDateTime;
begin
  DT := TDateTime.NowUTC;
  Result := MilliSecondsBetween(DT, UnixDateDelta);
end;
{$ENDIF}

function DateTimeToUNIXTimeInMilliseconds(const dt : TDateTime): UInt64;inline;
begin
  Result := MilliSecondsBetween(dt, UnixDateDelta);
end;

  const Variant10xxMask : byte = $C0;
  const Variant10xxValue : byte = $80;

  const VersionMask : word = $F000;
  const Version7Value : word =  $7000;

{ TUUIDV7Helper }

class function TUUIDV7Helper.CreateV7: TGuid;
var
  timestamp : UInt64;
begin
  result := TGUID.NewGuid;
  timestamp := UNIXTimeInMilliseconds;
  result.D1 := Cardinal(timestamp shr 16);
  result.D2 := Word(timestamp);
  result.D3 := (result.D3 and (not VersionMask)) or Version7Value;
  result.D4[0] := (result.D4[0] and (not Variant10xxMask)) or Variant10xxValue ;
end;

class function TUUIDV7Helper.CreatedUTC(const guid: TGUID): TDateTime;
var
  timestamp : UInt64;
begin
  timestamp := (UInt64(guid.D1) shl 16) or UInt64(guid.D2) ;
  result := (timestamp / MSecsPerDay ) + UnixDateDelta;
end;

class function TUUIDV7Helper.CreateV7(const dt: TDateTime): TGuid;
var
  timestamp : UInt64;
begin
  result := TGUID.NewGuid;
  timestamp := DateTimeToUNIXTimeInMilliseconds(dt);
  result.D1 := Cardinal(timestamp shr 16);
  result.D2 := Word(timestamp);
  result.D3 := (result.D3 and (not VersionMask)) or Version7Value;
  result.D4[0] := (result.D4[0] and (not Variant10xxMask)) or Variant10xxValue ;
end;

class function TUUIDV7Helper.IsV7(const guid: TGuid): boolean;
begin
 result := Version(guid) = 7;
end;


class function TUUIDV7Helper.Version(const guid: TGuid): integer;
begin
 result := integer(guid.D3 shr 12);
end;

end.
