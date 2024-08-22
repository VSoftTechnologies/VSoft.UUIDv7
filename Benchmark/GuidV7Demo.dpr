program GuidV7Demo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.DateUtils,
  Spring.Benchmark,
  VSoft.UUIDv7 in '..\Source\VSoft.UUIDv7.pas';


procedure BM_CreateV4(const state: TState);
begin
  // Perform setup here
  for var _ in state do
  begin
    // This code gets timed
    var guid :=TGuid.NewGuid;
  end;
end;


procedure BM_CreateV7(const state: TState);
begin
  // Perform setup here
  for var _ in state do
  begin
    // This code gets timed
    var guid :=TUUIDv7Helper.CreateV7;
  end;
end;

procedure BM_CreateV7_DT(const state: TState);
begin
  var dt := Now;
  // Perform setup here
  for var _ in state do
  begin
    // This code gets timed
    var guid :=TUUIDv7Helper.CreateV7(dt);
  end;
end;


//TODO: move to unit tests!
//hacky little test

procedure test;
var
  guid : TGuid;
  dt : TDateTime;
  v : integer;
begin
  guid := TGUID.NewGuid;
  writeln(guid.ToString);
  if (TUUIDv7Helper.IsV7(guid)) then
    Writeln('v7 true')
  else
    Writeln('v7 false');

  v := TUUIDV7Helper.Version(guid);
  writeln('version : ' + IntTostr(v));

  guid := TUUIDv7Helper.CreateV7;
  writeln(guid.ToString);
  if (TUUIDv7Helper.IsV7(guid)) then
    Writeln('v7 true')
  else
    Writeln('v7 false');

  v := TUUIDV7Helper.Version(guid);
  writeln('version : ' + IntTostr(v));


  dt := TUUIDv7Helper.CreatedUTC(guid);
  writeln(dt.ToString);


end;


begin
  test;
//  Benchmark(BM_CreateV4, 'TGuid.NewGuid');
//  Benchmark(BM_CreateV7, 'TGuidV7Helper.CreateV7');
//  Benchmark(BM_CreateV7_DT, 'TGuidV7Helper.CreateV7(datetime)');
//  // Run the benchmark
//  Benchmark_Main;
  readln;
end.
