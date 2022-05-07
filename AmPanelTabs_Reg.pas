unit AmPanelTabs_Reg;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,Types,
  DesignEditors,DesignIntf,AmPanelTabsCustom,AmPanelTabs;

 type
    TAmPageControlCustom_ComEditor=class(TDefaultEditor)
      public
        function GetVerbCount:integer; override;
        function GetVerb(Index:integer):string; override;
        procedure ExecuteVerb(Index: Integer); override;
        procedure Edit; override;
    end;
procedure Register;

implementation
procedure Register;
begin
  RegisterComponents('AmTabs', [TAmPageControlCustom]);
  RegisterComponents('AmTabs', [TAmPageCustom]);

  RegisterComponents('AmTabs', [TAmPageControlIB]);
  RegisterComponents('AmTabs', [TAmPageIB]);

  RegisterComponentEditor(TAmPageControlCustom,TAmPageControlCustom_ComEditor);
  RegisterComponentEditor(TAmPageControlIB,TAmPageControlCustom_ComEditor);
end;

function TAmPageControlCustom_ComEditor.GetVerbCount:integer;
begin
     Result:= inherited ;
     Result:= Result +2;
end;
function TAmPageControlCustom_ComEditor.GetVerb(Index:integer):string;
begin
  inherited ;
  case Index of
    0:Result:='NewPage';
    1:Result:='DeletePage';
   // 2:Result:='&Edit...';
  end;
end;
procedure TAmPageControlCustom_ComEditor.ExecuteVerb(Index: Integer);
var P:TAmPageControlCustom;
var Page:TAmPageCustom;
begin
    inherited;
    case Index of
           0:begin
              P:= TAmPageControlCustom(self.Component);

             // Tab :=TAmPanelTabCustom(Designer.CreateChild(TAmPanelTabCustom, P.ClientPanel));

              Page :=TAmPageCustom(Designer.CreateComponent(P.GetClassPage,P,0,0,100,100));
              Page.TabIndexDesign:= P.GetNextTabIndexDesign;
              Page.PageControl := P;

              //Designer.Modified;

           end;
           1:begin
              P:= TAmPageControlCustom(self.Component);
              if Assigned(P.ActivePage) then P.ActivePage.Free;

              
           end;
    end;
end;

Function MouseControlAtPos(Pos:TPoint;WC:TWincontrol=nil):TControl;
var
 cl,cl_tmp:TControl;
begin
 Result:=nil;
 if Assigned(WC) then
 begin
    cl := WC.ControlAtPos(WC.ScreenToClient(Pos),true,true);
    while assigned(cl) and (cl is TWinControl) do
    begin
     cl_tmp:=TWinControl(cl).ControlAtPos(TWinControl(cl).ScreenToClient(Pos),true,true);
     if assigned(cl_tmp) then cl:=cl_tmp else break;
    end;
    Result:=cl;
 end
 else
 begin



  if Screen.ActiveForm<>nil then
   with Screen.ActiveForm do
   begin
    cl := ControlAtPos(ScreenToClient(Pos),true,true);
    while assigned(cl) and (cl is TWinControl) do
    begin
     cl_tmp:=TWinControl(cl).ControlAtPos(TWinControl(cl).ScreenToClient(Pos),true,true);
     if assigned(cl_tmp) then cl:=cl_tmp else break;
    end;
    Result:=cl;
   end;
 end;

end;
procedure TAmPageControlCustom_ComEditor.Edit;
var P:TAmPageControlCustom;
C:TControl;
  I: Integer;
begin
    P:= TAmPageControlCustom(self.Component);
    C:=MouseControlAtPos(mouse.CursorPos,P);

   while Assigned(C)
   and not (C is TAmTabCustom) do
   C:= C.Parent;

   if  not Assigned(C) then exit;

   for I := 0 to P.PageCount-1 do
   if C = P.Pages[i].Tab then
   begin
   P.ActivePage:= P.Pages[i];
   break;
   end;

     

 //    P.ActivePageIndex:= P.ActivePageIndex+1;
end;
end.
