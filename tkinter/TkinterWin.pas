unit TkinterWin;

interface

uses
     //
     SysVars,

     //
     teUnit,

     //
     JsonDataObjects,

     //
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,ComObj,
     Dialogs, ExtCtrls, StdCtrls, ComCtrls, ImgList, ToolWin, System.ImageList, Vcl.Buttons,
     Vcl.Samples.Spin;

type
  TForm_TkinterEditor = class(TForm)
    Panel_Right: TPanel;
    Panel_Client: TPanel;
    Panel_Form: TPanel;
    Panel_FormTitle: TPanel;
    Panel_FormClient: TPanel;
    Label_Caption: TLabel;
    SpeedButton_FormClose: TSpeedButton;
    SpeedButton_Min: TSpeedButton;
    SpeedButton_Max: TSpeedButton;
    ImageList: TImageList;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    FontDialog: TFontDialog;
    ToolBar1: TToolBar;
    ToolButton_Label: TToolButton;
    ToolButton_Button: TToolButton;
    ToolButton_Checkbutton: TToolButton;
    ToolButton_Radiobutton: TToolButton;
    ToolButton_Entry: TToolButton;
    ToolButton_Listbox: TToolButton;
    ToolButton_Text: TToolButton;
    ToolButton_Scale: TToolButton;
    ToolButton1: TToolButton;
    ToolButton_Delete: TToolButton;
    ToolButton4: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton_Select: TToolButton;
    Splitter1: TSplitter;
    //
    procedure Label_CaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Label_CaptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ToolButton_DeleteClick(Sender: TObject);
    procedure ToolButton_CancelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel_FormClientMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;  X, Y: Integer);
    procedure ToolButton_SelectClick(Sender: TObject);
  private
    { Private declarations }
  public
     PythonCode : string;
     gjoWindow : TJsonObject;
     procedure ControlMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
     procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
     procedure ShowComponentInfo(ACtrl:TControl);
     procedure SelectComponent(APanel:TPanel);
     procedure OnPropertyChange(Sender:TObject);
     function  CreateParentPanel(AIndex:Integer):TPanel;
     function  CreateComponent(ANode:TJsonObject;AIndex:Integer):TControl;
  end;

var
     Form_TkinterEditor  : TForm_TkinterEditor;
function CreateGUIDName:string;

implementation

{$R *.dfm}

function CreateGUIDName:string;
begin
     Result    := CreateClassID;
     Delete(Result,1,1);
     Delete(Result,Length(Result),1);
     Result    := 'A'+StringReplace(Result,'-','',[rfReplaceAll]);
end;


procedure TForm_TkinterEditor.Button1Click(Sender: TObject);
var
     iItem     : Integer;
     joModule  : TJsonObject;
begin

end;

procedure TForm_TkinterEditor.ControlMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
     oControl  : TControl;
     iTag      : Integer;
begin

     ReleaseCapture;
     //
     oControl  := TControl(Sender);
     //
     iTag := oControl.Tag;
     while iTag > 0 do begin
          oControl  := oControl.Parent;
          Dec(iTag);
     end;

     //
     ShowComponentInfo(oControl);


     //
     if (x>=0)and(x<=3) then begin
          if (y>=0)and(y<=3) then oControl.Perform(WM_SysCommand,$F004,0);
          if (y>3)and(y<oControl.Height-3) then oControl.Perform(WM_SysCommand,$F001,0);
          if (y>=oControl.Height-3)and(y<=oControl.Height) then oControl.Perform(WM_SysCommand,$F007,0);
     end else if (x>3)and(x<oControl.Width-3) then begin
          if (y>=0)and(y<=3) then oControl.Perform(WM_SysCommand,$F003,0);
          if (y>3)and(y<oControl.Height-3) then oControl.Perform(WM_SysCommand,$F012,0);
          if (y>=oControl.Height-3)and(y<=oControl.Width) then oControl.Perform(WM_SysCommand,$F006,0);
     end else if (x>=oControl.Width-3)and(x<=oControl.Width) then begin
          if (y>=0)and(y<=3) then oControl.Perform(WM_SysCommand,$F005,0);
          if (y>3)and(y<oControl.Height-3) then oControl.Perform(WM_SysCommand,$F002,0);
          if (y>=oControl.Height-3)and(y<=oControl.Width) then oControl.Perform(WM_SysCommand,$F008,0);
     end;

     //TPanel(oControl).BevelOuter     := bvSpace;
end;

procedure TForm_TkinterEditor.ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
     oControl  : TControl;
     //
     iTag      : Integer;
     iItem     : Integer;
     //
     joNode    : TJsonObject;

begin
     if Sender = Panel_FormClient then begin
          Exit;
     end;
     if Sender = Panel_FormTitle then begin
          Exit;
     end;

     //
     oControl  := TControl(Sender);

     //
     iTag := oControl.Tag;
     while iTag > 0 do begin
          oControl  := oControl.Parent;
          Dec(iTag);
     end;

     //
     if (x>=0)and(x<=3) then begin
          if (y>=0)and(y<=3) then oControl.Cursor:=crSizeNWSE;
          if (y>3)and(y<oControl.Height-3) then oControl.Cursor:=crSizeWE;
          if (y>=oControl.Height-3)and(y<=oControl.Height) then oControl.Cursor:=crSizeNESW;
     end else if (x>3)and(x<oControl.Width-3) then begin
          if (y>=0)and(y<=3) then oControl.Cursor:=crSizeNS;
          if (y>3)and(y<oControl.Height-3) then oControl.Cursor:=crArrow;
          if (y>=oControl.Height-3)and(y<=oControl.Width) then oControl.Cursor:=crSizeNS;
     end else if (x>=oControl.Width-3)and(x<=oControl.Width) then begin
          if (y>=0)and(y<=3) then oControl.Cursor:=crSizeNESW;
          if (y>3)and(y<oControl.Height-3) then oControl.Cursor:=crSizeWE;
          if (y>=oControl.Height-3)and(y<=oControl.Width) then oControl.Cursor:=crSizeNWSE;
     end;

     //找到相应的JSON
     joNode    := nil;
     for iItem := 0 to gjoWindow.A['items'].Count-1 do begin
          if gjoWindow.A['items'][iItem].S['guid'] = oControl.Hint then begin
               joNode    :=  gjoWindow.A['items'][iItem];
               Break;
          end;
     end;
     if joNode = nil then begin
          Exit;
     end;

     //更新相应的JSON
     joNode.I['left']    := oControl.Left;
     joNode.I['top']     := oControl.Top;
     joNode.I['width']   := oControl.Width;
     joNode.I['height']  := oControl.Height;



     //更新相应的JSON的属性
     teShowNodeProperty(joNode,Panel_Right);
end;

procedure TForm_TkinterEditor.Label_CaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
     oControl  : TControl;
     oPanel         : TPanel;
begin

     ReleaseCapture;
     oControl  := TControl(Sender);
     if (x>0)and(x<oControl.Width-1) then begin
          if (y>0)and(y<oControl.Height-1) then oControl.Parent.Parent.Perform(WM_SysCommand,$F012,0);
     end;

end;

procedure TForm_TkinterEditor.Label_CaptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
     oControl  : TControl;
begin
     if Sender = Panel_FormClient then begin
          Exit;
     end;
     if Sender = Panel_FormTitle then begin
          Exit;
     end;

     oControl  := TControl(Sender);
     if (x>3)and(x<oControl.Width-3) then begin
          if (y>3)and(y<oControl.Height-3) then oControl.Parent.Parent.Cursor:=crArrow;
     end;
end;

procedure TForm_TkinterEditor.OnPropertyChange(Sender: TObject);
var
     joNode    : TJsonObject;
begin
     //
     //joNode    := teTreeToJson(tnNode);

     //
     if Sender.ClassType = TSpeedButton then begin
          if FontDialog.Execute then begin
               TSpeedButton(Sender).Font     := FontDialog.Font;
          end;
     end;

     //
     teSaveNodeProperty(joNode,Panel_Right);

end;

procedure TForm_TkinterEditor.Panel_FormClientMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
     oPanel    : TPanel;
     joNode    : TJsonObject;
begin
     if ToolBar1.Hint <> 'select' then begin
          //添加JSON
          with gjoWindow.A['items'].AddObject do begin
               teAddJsonModule(gjoWindow,-1,ToolBar1.Hint);
          end;

          //
          joNode    := gjoWindow.A['items'][gjoWindow.A['items'].Count-1];
          oPanel    := TPanel(CreateComponent(joNode,gjoWindow.A['items'].Count-1));
          oPanel.Left    := X;
          oPanel.Top     := Y;
          //
          joNode.I['left']    := X;
          joNode.I['top']     := Y;
     end;
end;

procedure TForm_TkinterEditor.FormCreate(Sender: TObject);
begin
     gjoWindow := TJsonObject.Create;
     //
     gjoWindow.S['name']      := 'tk_window';
     gjoWindow.S['caption']   := 'tkinter window';
     gjoWindow.I['left']      := 100;
     gjoWindow.I['top']       := 100;
     gjoWindow.I['width']     := 500;
     gjoWindow.I['height']    := 300;
     gjoWindow.A['color'].FromUtf8JSON('[240,240,240]');
     //
     gjoWindow.S['guid']      := CreateGUIDName;
     //
     gjoWindow.A['items']     := TJsonArray.Create;


     //
     if gjoModules = nil then begin
          gjoModules     := TJsonObject.Create;
          gjoModules.LoadFromFile('modules.json');
     end;
end;


function TForm_TkinterEditor.CreateParentPanel(AIndex:Integer):TPanel;
begin
     Result    := TPanel.Create(Panel_FormClient);
     Result.Parent            := Panel_FormClient;
     Result.BorderWidth       := 2;
     Result.BevelOuter        := bvNone;
     Result.ParentBackground  := False;
     Result.OnMouseDown       := ControlMouseDown;
     Result.OnMouseMove       := ControlMouseMove;
     Result.Name              := CreateGUIDName;
     Result.Caption           := '';
     Result.Tag               := -(AIndex+1);
end;


//
function TForm_TkinterEditor.CreateComponent(ANode: TJsonObject;AIndex:Integer): TControl;
var
     //
     oPanel         : TPanel;
     //
     oLabel         : TPanel;
     oCheckbutton   : TCheckBox;
     oRadiobutton   : TRadioButton;
     oButton        : TButton;
     oEntry         : TEdit;
     oListBox       : TListBox;
     oText          : TMemo;
     oScale         : TProgressBar;
     procedure _SetLTWH(AControl:TPanel;ANode:TJsonObject);
     begin
          AControl.Left  := ANode.I['left'];
          AControl.Top   := ANode.I['top'];
          AControl.Width := ANode.I['width'];
          AControl.Height:= ANode.I['height'];
          teJsonToFont(AControl.Font,ANode.O['font']);
     end;
begin
     //
     if ANode.S['name'] = 'tk_label' then begin
          oPanel    := CreateParentPanel(AIndex);
          //用于相互联系
          ANode.S['guid']     := oPanel.Name;
          //
          _SetLTWH(oPanel,ANode);
          //
          oLabel              := TPanel.Create(oPanel);
          oLabel.Parent       := oPanel;
          oLabel.Align        := alClient;
          oLabel.Tag          := 1;
          oLabel.Alignment    := taLeftJustify;
          oLabel.BevelOuter   := bvNone;
          oLabel.ParentFont   := True;
          //
          oLabel.Caption      := ANode.S['caption'];
          oLabel.Color        := teArrayToColor(ANode.A['color']);
          if ANode.S['anchor'] = 'e' then begin  //"e","w","n","s","ne","se","sw","sn","center"
               oLabel.Alignment    := taRightJustify;
          end else if ANode.S['anchor'] = 'ne' then begin
               oLabel.Alignment    := taRightJustify;
          end else if ANode.S['anchor'] = 'se' then begin
               oLabel.Alignment    := taRightJustify;
          end else if ANode.S['anchor'] = 'w' then begin
               oLabel.Alignment    := taLeftJustify;
          end else if ANode.S['anchor'] = 'nw' then begin
               oLabel.Alignment    := taLeftJustify;
          end else if ANode.S['anchor'] = 'sw' then begin
               oLabel.Alignment    := taLeftJustify;
          end else if ANode.S['anchor'] = 'center' then begin
               oLabel.Alignment    := taCenter;
          end;
          //
          oLabel.OnMouseDown  := ControlMouseDown;
          oLabel.OnMouseMove  := ControlMouseMove;
          //
          oLabel.Color        := teArrayToColor(ANode.A['color']);

          //
     end else if ANode.S['name'] = 'tk_button' then begin
          oPanel    := CreateParentPanel(AIndex);
          //用于相互联系
          ANode.S['guid']     := oPanel.Name;
          //
          _SetLTWH(oPanel,ANode);
          //
          oButton             := TButton.Create(oPanel);
          oButton.Parent      := oPanel;
          oButton.Caption     := ANode.S['caption'];
          oButton.Align       := alClient;
          oButton.Tag         := 1;
          oButton.OnMouseDown := ControlMouseDown;
          oButton.OnMouseMove := ControlMouseMove;
     end else if ANode.S['name'] = 'tk_check' then begin
          oPanel    := CreateParentPanel(AIndex);
          //用于相互联系
          ANode.S['guid']     := oPanel.Name;
          //
          _SetLTWH(oPanel,ANode);
          //
          oCheckbutton             := TCheckBox.Create(oPanel);
          oCheckbutton.Parent      := oPanel;
          oCheckbutton.Caption     := ANode.S['caption'];
          oCheckbutton.Align       := alClient;
          oCheckbutton.Tag         := 1;
          oCheckbutton.OnMouseDown := ControlMouseDown;
          oCheckbutton.OnMouseMove := ControlMouseMove;
     end else if ANode.S['name'] = 'tk_radio' then begin
          oPanel    := CreateParentPanel(AIndex);
          //用于相互联系
          ANode.S['guid']     := oPanel.Name;
          //
          _SetLTWH(oPanel,ANode);
          //
          oRadiobutton             := TRadioButton.Create(oPanel);
          oRadiobutton.Parent      := oPanel;
          oRadiobutton.Caption     := ANode.S['caption'];
          oRadiobutton.Align       := alClient;
          oRadiobutton.Tag         := 1;
          oRadiobutton.OnMouseDown := ControlMouseDown;
          oRadiobutton.OnMouseMove := ControlMouseMove;
     end else if ANode.S['name'] = 'tk_entry' then begin
          oPanel    := CreateParentPanel(AIndex);
          //用于相互联系
          ANode.S['guid']     := oPanel.Name;
          //
          _SetLTWH(oPanel,ANode);
          //
          oEntry              := TEdit.Create(oPanel);
          oEntry.Parent       := oPanel;
          oEntry.Text         := ANode.S['caption'];
          oEntry.Align        := alClient;
          oEntry.Tag          := 1;
          oEntry.OnMouseDown  := ControlMouseDown;
          oEntry.OnMouseMove  := ControlMouseMove;
     end else if ANode.S['name'] = 'tk_listbox' then begin
          oPanel         := CreateParentPanel(AIndex);
          //用于相互联系
          ANode.S['guid']     := oPanel.Name;
          //
          _SetLTWH(oPanel,ANode);
          //
          oListBox         := TListBox.Create(oPanel);
          oListBox.Parent  := oPanel;
          oListBox.Items.Text := 'Python';
          oListBox.Items.Add('Delphi');
          oListBox.Items.Add('Java');
          oListBox.Items.Add('JavaScript');
          oListBox.Align      := alClient;
          oListBox.Tag        := 1;
          oListBox.OnMouseDown:= ControlMouseDown;
          oListBox.OnMouseMove:= ControlMouseMove;
     end else if ANode.S['name'] = 'tk_text' then begin
          oPanel    := CreateParentPanel(AIndex);
          //用于相互联系
          ANode.S['guid']     := oPanel.Name;
          //
          _SetLTWH(oPanel,ANode);
          //
          oText               := TMemo.Create(oPanel);
          oText.Parent        := oPanel;
          oText.Text          := ANode.S['caption'];
          oText.Align         := alClient;
          oText.Tag           := 1;
          oText.OnMouseDown   := ControlMouseDown;
          oText.OnMouseMove   := ControlMouseMove;
     end else if ANode.S['name'] = 'tk_scale' then begin
          oPanel    := CreateParentPanel(AIndex);
          //用于相互联系
          ANode.S['guid']     := oPanel.Name;
          //
          _SetLTWH(oPanel,ANode);
          //
          oScale              := TProgressBar.Create(oPanel);
          oScale.Parent       := oPanel;
          oScale.Position     := 30;
          oScale.Align        := alClient;
          oScale.Tag          := 1;
          oScale.OnMouseDown  := ControlMouseDown;
          oScale.OnMouseMove  := ControlMouseMove;
     end;
     Result    := oPanel;

end;


procedure TForm_TkinterEditor.FormShow(Sender: TObject);
var
     iTab      : Integer;
     iItem     : Integer;
     joItem    : TJsonObject;

begin

     //
     with Panel_Form do begin
          Left      := gjoWindow.I['left'];
          Top       := gjoWindow.I['top'];
          Width     := gjoWindow.I['width'];
          Height    := gjoWindow.I['height']+38;
          //
          Label_Caption.Caption    := gjoWindow.S['caption'];
          Panel_FormClient.Color   := teArrayToColor(gjoWindow.A['color']);
     end;

     //
     for iItem := 0 to gjoWindow.A['items'].Count-1 do begin
          joItem    := gjoWindow.A['items'][iItem];

          //
          CreateComponent(joItem,iItem);
     end;

     //默认选择窗体
     Label_Caption.OnMouseDown(Label_Caption,mbLeft, [], 10, 10);
end;

procedure TForm_TkinterEditor.SelectComponent(APanel: TPanel);
var
     iCtrl     : Integer;
     oPanel    : TPanel;
begin
     //Exit;
     //
     for iCtrl := 0 to Panel_FormClient.ControlCount-1 do begin
          oPanel    := TPanel(Panel_FormClient.Controls[iCtrl]);
          if oPanel <> APanel then begin
               oPanel.Color        := clBtnFace;
          end;
     end;
     APanel.Color   := clMedGray;
end;

procedure TForm_TkinterEditor.ShowComponentInfo(ACtrl: TControl);
var
     oPanel         : TPanel;
     //
     oLabel         : TPanel;
     oCheckbutton   : TCheckBox;
     oRadiobutton   : TRadioButton;
     oButton        : TButton;
     oEntry         : TEdit;
     oListBox       : TListBox;
     oText          : TMemo;
     oScale         : TProgressBar;

     //
     joNode         : TJsonObject;
     joModule       : TJsonObject;
begin
     //
     if ACtrl = nil then begin
          Exit;
     end;

     if (ACtrl = Panel_Form)or(ACtrl = Panel_FormClient)or(ACtrl = Label_Caption) then begin
          //显示gjoWindow的属性
          teShowNodeProperty(gjoWindow,Panel_Right);
          //
          Panel_Right.Tag   := -999;
     end else begin
          //
          if ACtrl.Tag < 0 then begin
               oPanel    := TPanel(ACtrl);
          end else begin
               oPanel    := TPanel(ACtrl.Parent);
          end;
          //
          if oPanel = Panel_Client then Exit;



          if oPanel.Tag < 0 then begin
               //得到当前控件对应的JSON
               joNode    := gjoWindow.A['items'][-oPanel.Tag-1];

               //
               teShowNodeProperty(joNode,Panel_Right);
               Panel_Right.Tag   := oPanel.Tag;

               //
               SelectComponent(oPanel);
          end;
     end;
end;

procedure TForm_TkinterEditor.ToolButton_CancelClick(Sender: TObject);
begin
     ModalResult    := mrCancel;
end;

procedure TForm_TkinterEditor.ToolButton_DeleteClick(Sender: TObject);
var
     iCtrl     : Integer;
     oPanel    : TPanel;
begin
     oPanel := nil;
     for iCtrl := 0 to Panel_FormClient.ControlCount-1 do begin
          if TPanel(Panel_FormClient.Controls[iCtrl]).Color <> clBtnFace then begin
               oPanel    := TPanel(Panel_FormClient.Controls[iCtrl]);
               Break;
          end;
     end;

     //
     if oPanel = nil then begin
          Exit;
     end;

     //
     if MessageDlg('Are you sure delete the component ?',mtConfirmation,[mbOK,mbCancel],0)= mrOk then begin
          oPanel.Destroy;
          //select form_window as default
          Label_Caption.OnMouseDown(Label_Caption,mbLeft, [], 10, 10);
     end;

end;

procedure TForm_TkinterEditor.ToolButton_SelectClick(Sender: TObject);
begin
     ToolBar1.Hint  := TToolButton(Sender).Hint;
end;

end.
