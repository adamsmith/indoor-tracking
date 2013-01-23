VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command2 
      Caption         =   "Make Raw Files"
      Height          =   495
      Left            =   3120
      TabIndex        =   6
      Top             =   1200
      Width           =   1455
   End
   Begin VB.ListBox List2 
      Height          =   255
      Left            =   2880
      TabIndex        =   5
      Top             =   3120
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.ListBox List1 
      Height          =   255
      Left            =   4200
      TabIndex        =   4
      Top             =   2880
      Visible         =   0   'False
      Width           =   495
   End
   Begin VB.FileListBox File1 
      Height          =   285
      Left            =   3360
      TabIndex        =   3
      Top             =   2880
      Visible         =   0   'False
      Width           =   615
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Process All Files"
      Height          =   495
      Left            =   3120
      TabIndex        =   2
      Top             =   600
      Width           =   1455
   End
   Begin VB.DirListBox Dir1 
      Height          =   2340
      Left            =   120
      TabIndex        =   1
      Top             =   600
      Width           =   2895
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   120
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   120
      Width           =   4455
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
File1.Path = Text1.Text
File1.Refresh
For i = 0 To File1.ListCount - 1
    myfile = File1.Path & "\" & File1.List(i)
    FileCopy myfile, File1.Path & "\" & Mid(File1.List(i), 1, Len(File1.List(i)) - 4) & "_raw.log"
    List1.Clear
    Open myfile For Input As #1 ' Open file.
    Do While Not EOF(1) ' Loop until end of file.
        Line Input #1, texttemp
        If InStr(1, texttemp, "-1", vbTextCompare) = 0 Then
            List1.AddItem texttemp
        End If
    Loop
    List2.Clear
    For j = 0 To List1.ListCount - 1
        For k = 0 To Len(List1.List(j)) - 1
            mychr = Mid(List1.List(j), k, 1)
            If (Asc(mychr) >= 48 And Asc(mychr) <= 57) Or Asc(mychr) = 44 Then
                List2.AddItem List1.List(j)
            End If
        Next
    Next
    Close #1
    Kill myfile
    Open myfile For Output As #2
    For j = 0 To List2.ListCount - 1
        Print #2, List2.List(j)
    Next
    Close #2
Next
End Sub

Private Sub Command2_Click()
File1.Path = Text1.Text
File1.Refresh
For i = 0 To File1.ListCount - 1
    myfile = File1.Path & "\" & File1.List(i)
    FileCopy myfile, File1.Path & "\" & Mid(File1.List(i), 1, Len(File1.List(i)) - 4) & "_raw.log"
Next
End Sub

Private Sub Dir1_Change()
Text1.Text = Dir1.Path
End Sub

Public Function filefn(X As String, Optional target As String) As String
'On Error Goto err
If target = "" Then target = "\"
Dim i As Integer
For i = Len(X) To 1 Step -1
If Mid(X, i, 1) = target Then
filefn = Mid(X, i + 1)
Exit Function
End If
Next
Exit Function
err:
End Function
