// Copyright (c) 2014 Sean Phillips
// Distributed under the BSD License (see LICENSE.md for full license text)
//
// MainForm.pas
// 	Defines the application logic in its entirety.

unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, System.IniFiles,
  IdHTTP;

type
  TfrmMain = class(TForm)
    editIn: TEdit;
    editOut: TEdit;
    lblArrow: TLabel;
    trayIcon: TTrayIcon;
    trayMenu: TPopupMenu;
    Exit1: TMenuItem;
    N1: TMenuItem;
    CurrencyConverter1: TMenuItem;
    Update1: TMenuItem;
    lblUpdated: TLabel;
    procedure editInChange(Sender: TObject);
    procedure trayIconClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Exit1Click(Sender: TObject);
    procedure lblUpdatedClick(Sender: TObject);
    procedure Update1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  convEURtoUSD,convEURtoGBP,convUSDtoEUR,convGBPtoEUR: Double;

implementation

{$R *.dfm}


//---------- FUNCTIONS --------------------------

// Gets the height of the taskbar
// Used to place the form just above the taskbar as a "tray popup"
function TaskBarHeight: integer;
var
  tbHWND: HWND;
  tbRect: TRect;
begin
  tbHWND := FindWindow('Shell_TrayWnd', '');
  if tbHWND = 0 then
    Result := 0
  else
  begin
    GetWindowRect(tbHWND, tbRect);
    Result := tbRect.Bottom - tbRect.Top;
  end;
end;


// Gets exchange rate from "fromCur" to "toCur"
// Taken from http://rate-exchange.appspot.com/currency using IdHttp
// Use sparingly!
function GetExchangeRate(fromCur,toCur:String):Double;
var
  http:TIdHttp;
  s:String;
begin
  Sleep(500);
  try
    http:=TIdHttp.Create();
    s:=http.Get('http://rate-exchange.appspot.com/currency?from='+fromCur+'&to='+toCur);
    result:=StrToFloat(Copy(s,AnsiPos('"rate": ',s)+7,6));
  except
    result:=-1;
  end;
  Application.ProcessMessages;
end;

// Loads settings from INI
procedure LoadSettings;
var
  ini:TIniFile;
begin
  ini:=TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  frmMain.lblUpdated.Caption:='Exchange Rates Correct as of ' + ini.ReadString('LATEST','Updated','never.');
  convEURtoGBP:=ini.ReadFloat('LATEST','EGBP',0.836459);
  convEURtoUSD:=ini.ReadFloat('LATEST','EUSD',1.37404);
  convGBPtoEUR:=ini.ReadFloat('LATEST','GBPE',1.19552);
  convUSDtoEUR:=ini.ReadFloat('LATEST','USDE',0.72778);
  ini.Free;
end;

// Saves settings to INI
procedure SaveSettings(eg,ed,ge,de:Double);
var
  ini:TIniFile;
begin
  ini:=TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  ini.WriteFloat('LATEST','EGBP',eg);
  ini.WriteFloat('LATEST','EUSD',ed);
  ini.WriteFloat('LATEST','GBPE',ge);
  ini.WriteFloat('LATEST','USDE',de);
  ini.WriteString('LATEST','Updated',DateTimeToStr(Now));
  ini.Free;
end;

// Updates exchange rates, saves them to IniFile if successful, then loads the
// new settings
procedure UpdateExchangeRates;
var
eg,ed,de,ge:Double;
res:Boolean;
begin
  res:=True;
  eg:=GetExchangeRate('EUR','GBP');
  if eg=-1 then
    res:=False;
  ed:=GetExchangeRate('EUR','USD');
  if ed=-1 then
    res:=False;
  de:=GetExchangeRate('USD','EUR');
  if de=-1 then
    res:=False;
  ge:=GetExchangeRate('GBP','EUR');
  if ge=-1 then
    res:=False;

  if res=True then
  begin
    SaveSettings(eg,ed,ge,de);
    LoadSettings;
  end
    else
  begin
    frmMain.lblUpdated.Caption:='Update failed.';
  end;
  Application.ProcessMessages;
end;

// Takes in currency value (eg. "$24.60") and returns the appropriate converted
// value (eg. "€16.22") based on current conversion values.
function DoConvert(s:String):String;
var
  value,conv:Double;
begin
  if not (s='') then
  begin
    case s[1] of
      '$': conv:=convUSDtoEUR;
      '£': conv:=convGBPtoEUR;
      '€': conv:=-1;
      else conv:=0;
    end;

    Delete(s,1,1);

    try
      value:=StrToFloat(s);
    except
      value:=0.00;
    end;

    if conv=-1 then
    begin
      conv:=convEURtoGBP;
      result:='£'+FloatToStrF(conv*value,ffNumber,16,2)+'  |  ';
      conv:=convEURtoUSD;
      result:=result+'$'+FloatToStrF(conv*value,ffNumber,16,2);
    end
    else
      result:='€'+FloatToStrF(conv*value,ffNumber,16,2);
  end;
end;

// Fades the provided form out
procedure FadeOut(frm:TForm);
var
i:Integer;
begin
  i := 255;
  while i > 0 do
  begin
    Sleep(2);
    i := i - 1;
    frm.AlphaBlendValue := i;
  end;
end;
//-----------------------------------------------


//---------- GUI Updating --------------------------
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  LoadSettings;
  Self.Left := Screen.Width - Self.Width;
  Self.Top  := Screen.Height-Self.Height-TaskBarHeight;
end;

procedure TfrmMain.editInChange(Sender: TObject);
begin
  editOut.Text:=DoConvert(editIn.Text);
end;

procedure TfrmMain.lblUpdatedClick(Sender: TObject);
begin
  UpdateExchangeRates;
end;

procedure TfrmMain.Update1Click(Sender: TObject);
begin
  UpdateExchangeRates;
end;

procedure TfrmMain.trayIconClick(Sender: TObject);
var
  x:TCloseAction;
begin
  x:=caNone;
  if self.Visible then
    FormClose(Sender,x)
  else
  begin
    self.AlphaBlendValue:=255;
    self.Show;
  end;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FadeOut(self);
  self.Hide;
  Action:=caNone;
end;
//-----------------------------------------------

end.
