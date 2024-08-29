VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ISheetAccessor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit


' SheetAccessor�N���X�̊O���d�l���K�肷��C���^�t�F�[�X�ł�

' �w�肳�ꂽ�Z�������[�Ƃ��錩�o���̈�̍ŏI��̔ԍ���Ԃ�
Public Function FindLastColumn( _
    ByVal sheet As Worksheet, _
    ByVal rowIndex As Long, _
    ByVal colLeft As Long) As Long
End Function

' �w�肳�ꂽ��̍ŏI�s���擾
Public Function GetRowBottom( _
    ByVal sheet As Worksheet, _
    ByVal colLeft As Long) As Long
End Function

' �w�肳�ꂽ�͈͂̒l��2�����z��Ŏ擾
Public Function ReadMatrix( _
    ByVal sheet As Worksheet, _
    ByVal rowTop As Long, _
    ByVal colLeft As Long, _
    ByVal rowBottom As Long, _
    ByVal colRight As Long) As Variant
End Function

' �P�̍s�̃Z��(Row,Col1)�ƃZ��(Row,Col2)�ɂ���Ďw�肳�ꂽ�͈͂̃Z���l��1�����z��Ƃ��Ď擾
Public Function ReadSingleRow( _
    ByVal sheet As Worksheet, _
    ByVal rowIndex As Long, _
    ByVal colLeft As Long, _
    ByVal colRight As Long) As Variant
End Function

' �w�肳�ꂽ�͈͂�2�����z��̒l����������
Public Sub WriteMatrix( _
    ByVal sheet As Worksheet, _
    ByVal rowTop As Long, _
    ByVal colLeft As Long, _
    ByVal rowBottom As Long, _
    ByVal colRight As Long, _
    ByVal matrix As Variant)
End Sub

' (�si, ��i)�̃Z���̃e�L�X�g��Ԃ�
Public Function GetCellValue( _
    ByVal sheet As Worksheet, _
    ByVal rowIndex As Long, _
    ByVal colIndex As Long) As String
End Function

' (�si, ��j)�ɃZ�������݂��Ă�����True�A�������False��Ԃ�
Public Function CellExists( _
    ByVal sheet As Worksheet, _
    ByVal rowIndex As Long, _
    ByVal colIndex As Long) As Boolean
End Function




