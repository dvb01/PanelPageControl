unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,AmPanelTabsCustom,
  Vcl.StdCtrls,AmPanelTabs,AmControls, ES.BaseControls, ES.Images,
  AmFormPanelControls, Vcl.CheckLst, PngCheckListBox, HGM.Controls.PanelExt,
  HGM.Controls.PanelCollapsed, HGM.Controls.Labels, HGM.Controls.EditPanel,
  HGM.AutoTextType, HGM.Tools.Hint, Vcl.Grids, HGM.Controls.VirtualTable,
  HGM.License;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel3: TPanel;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    AmPageControlCustom1: TAmPageControlCustom;
    AmPageCustom1: TAmPageCustom;
    AmPageCustom2: TAmPageCustom;




    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    P:TAmPageControlIB;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var Tab:TAmPageIB;
B:TAmTabButtonClosePaint;
begin

// TAmPanelTabCustom.Create(self).Parent:=self;
  Tab:=P.addPage();
 // Tab.Tab.Caption:=Tab.PageIndex.ToString;
  Tab.Caption:=Tab.PageIndex.ToString;
  Tab.Color:=random(111255);
  Tab.Tab.ColorActive:= Tab.Color;
  Tab.Tab.LabelCaption.Font.Size:=12;
  Tab.Tab.ButtonClose.ButSize:=16;
  Tab.Tab.Caption:='sssssssss';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  P.TabsIsTop:= not P.TabsIsTop;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  P.ActivePage.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
var B:TAmPageControlCustom;
   Tab:TAmTabIB;
begin

 // //B.IsPagesTop:= not b.IsPagesTop;
  //Tab:=B.Pages[2];
 // Tab.TabIndexDesign:=B.GetNextTabIndexDesign;

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 P.Free;
// AmPanelPageControlCustom1.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//
ReportMemoryLeaksOnShutdown:=true;

P:=TAmPageControlIB.create(self);
P.parent:=Panel3;
P.Align:=alclient;
//P.Color:=clblack;


end;

end.
