program GuidV7Demo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Spring.Benchmark,
  VSoft.GUIDv7 in '..\Source\VSoft.GUIDv7.pas';


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
    var guid :=TGuidV7Helper.CreateV7;
  end;
end;

begin
  Benchmark(BM_CreateV4, 'TGuid.NewGuid');
  Benchmark(BM_CreateV7, 'TGuidV7Helper.CreateV7');
  // Run the benchmark
  Benchmark_Main;
  readln;
end.
