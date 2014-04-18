program CurrencyKing;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Obsidian');
  Application.Title := 'Currency Converter';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
