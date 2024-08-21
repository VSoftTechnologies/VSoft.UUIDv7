# VSoft.UUIDv7

A Delphi implementation of UUID v7 - [RFC 9562](https://datatracker.ietf.org/doc/rfc9562/)

UUID Version 7 is a time-ordered UUID which encodes a Unix timestamp with millisecond precision in the most significant 48 bits. As with all UUID formats, 6 bits are used to indicate the UUID version and variant. The remaining 74 bits are randomly generated. As UUIDv7 is time-ordered, values generated are practically sequential and therefore eliminates the index locality problem.

## Installation

### DPM

Install VSoft.UUIDv7 in the DPM IDE plugin,  or 
```
dpm install VSoft.UUIDv7 .\yourproject.dproj
```
### Manually
Clone the repository and add  VSoft.UUIDv7.pas file to your project, or add the repo\Source folder to your project's search path.

## Usage

```
var
  guid : TGuid;
begin
  guid := TUUIDv7Helper.CreateV7;
  writeln(guid.ToString);
end;
```
