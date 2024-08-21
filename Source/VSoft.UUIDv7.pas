unit VSoft.UUIDv7;

interface

type
  TGuidV7Helper = record
    class function CreateV7 : TGuid;static;
  end;

implementation

uses
  {$IFDEF MSWINDOWS}
  WinApi.Windows,
  {$ELSE}
  System.DateUtils
  {$ENDIF}
  System.SysUtils;



{$IFDEF MSWINDOWS}
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
  DT: TDateTime;
begin
  DT := TDateTime.NowUTC;
  Result := MilliSecondsBetween(DT, UnixDateDelta);
end;
{$ENDIF}

  const Variant10xxMask : byte = $C0;
  const Variant10xxValue : byte = $80;

  const VersionMask : word = $F000;
  const Version7Value : word =  $7000;

{ TGuidV7Helper }

class function TGuidV7Helper.CreateV7: TGuid;
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

end.
