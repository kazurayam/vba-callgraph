VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SheetAccessor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit


' Worksheet�𑀍삷�郁�\�b�h���܂Ƃ߂��N���X�ł�
'
' �s�ԍ��A��ԍ��͂P����n�܂�

Implements ISheetAccessor

' �w�肳�ꂽ�s�ԍ��Ɨ�ԍ����w���Z�������[�Ƃ���Range�܂��łȂ��Z���̘A���̈�̉E�[�̃Z���̔ԍ���Ԃ��B
' ���̊֐��̓V�[�g�̂Ȃ��́u���o���s�v�������Ă���񐔂�m�邽�߂ɗp����
Public Function ISheetAccessor_FindLastColumn( _
    ByVal sheet As Worksheet, _
    ByVal rowIndex As Long, _
    ByVal colLeft As Long) As Long
    ISheetAccessor_FindLastColumn = _
        sheet.Cells(rowIndex, colLeft).End(xlToRight).Column
End Function

' ��P�񂩂�w�肳�ꂽ��ԍ��܂ł͈̔͂Ƀf�[�^������ő�̍s�ԍ����擾
' ���̊֐��̓V�[�g�̂Ȃ��ŗL���ȃf�[�^�̍s���ő傢������m�邽�߂ɗp����
Public Function ISheetAccessor_GetRowBottom( _
    ByVal sheet As Worksheet, _
    ByVal col As Long) As Long
    ISheetAccessor_GetRowBottom = _
        sheet.Cells(sheet.Rows.Count, col).End(xlUp).Row
End Function

' �V�[�g�̃Z��(Row1,Col1)�ƃZ��(Row2, Col2)�ɂ���Ďw�肳�ꂽRange�I�u�W�F�N�g��
' Value��Ԃ��B�Ԃ����I�u�W�F�N�g��2�����z��ł���B
' Range�I�u�W�F�N�g��Value�͓����I�ł���B���Ȃ킿
' Value�̑�1������LBound�͕K��1��UBound�͕K��2�ł���B
' Value�̑�2������LBound�͕K��1��UBound��1�ȏ�̐����ł���B
'
Public Function ISheetAccessor_ReadMatrix( _
    ByVal sheet As Worksheet, _
    ByVal rowTop As Long, _
    ByVal colLeft As Long, _
    ByVal rowBottom As Long, _
    ByVal colRight As Long) As Variant
    ISheetAccessor_ReadMatrix = _
        sheet.Range(sheet.Cells(rowTop, colLeft), _
                    sheet.Cells(rowBottom, colRight)).Value
End Function

' �V�[�g�̃Z��(Row,Col1)�ƃZ��(Row,Col2)�ɂ���Ďw�肳�ꂽRange�I�u�W�F�N�g��Value�̂Ȃ�����
' 1�s�ڂ�array�����o���ĕԂ��B
' �Ԃ����1�����z���LBound��Col1�ɓ������AUBound��Col2�ɓ������B
Public Function ISheetAccessor_ReadSingleRow( _
    ByVal sheet As Worksheet, _
    ByVal rowIndex As Long, _
    ByVal colLeft As Long, _
    ByVal colRight As Long) As Variant
    
    Dim arrUtil As ArrayUtil: Set arrUtil = New ArrayUtil
    
    ' array2D��2�����z��
    Dim array2D As Variant
    array2D = ISheetAccessor_ReadMatrix(sheet, rowIndex, colLeft, rowIndex, colRight)
    
    ' array1D��1�����z��
    Dim array1D() As String
    ReDim array1D(colRight)
    
    ' array2D��1�s�ڂ����o����1�����z��𓾂�
    Dim i As Long
    For i = 1 To colRight - colLeft + 1
        array1D(i) = array2D(1, i)   ' 1�s�ڂ����o��
    Next
    
    ' �߂�l���Z�b�g
    ISheetAccessor_ReadSingleRow = array1D
    
End Function

' �w�肳�ꂽ�Z���͈͂�2�����z��̒l����������
Public Sub ISheetAccessor_WriteMatrix( _
    ByVal sheet As Worksheet, _
    ByVal rowTop As Long, _
    ByVal colLeft As Long, _
    ByVal rowBottom As Long, _
    ByVal colRight As Long, _
    ByVal matrix As Variant)
    sheet.Range(sheet.Cells(rowTop, colLeft), _
                sheet.Cells(rowBottom, colRight)).Value = matrix
End Sub

' �w�肳�ꂽ�s�ԍ��Ɨ�ԍ��ɊY������Z���ɕ\�����ꂽ�e�L�X�g��Ԃ�
Public Function ISheetAccessor_GetCellValue( _
    ByVal sheet As Worksheet, _
    ByVal rowIndex As Long, _
    ByVal colIndex As Long) As String
    Dim strBuf As String
    If ISheetAccessor_CellExists(sheet, rowIndex, colIndex) = True Then
        strBuf = sheet.Cells(rowIndex, colIndex).Value
        strBuf = Trim(strBuf)                   ' �O��̋󔒂��폜
        strBuf = Replace(strBuf, vbLf, "")      ' ���s���폜
        ' strBuf = StrConv(strBuf, vbNarrow)    ' �S�p�𔼊p��
        ' strBuf = StrConv(strBuf, vbUpperCase) ' �p��������啶����
    Else
        strBuf = "not exist"
    End If
    ISheetAccessor_GetCellValue = strBuf
End Function

' (i,j)�ɊY������Z�������݂��邩�ǂ����𒲂ׂ�True/False��Ԃ�
' �ł��A�Z���̗L���𒲂ׂ邱�Ƃ͖����ŁA���o����Text���󕶎���""���ǂ����Ŕ��f����
Public Function ISheetAccessor_CellExists( _
        ByVal sheet As Worksheet, _
        ByVal rowIndex As Long, _
        ByVal colIndex As Long) As Boolean
    Dim myRange As Range
    Dim t As String
    
    On Error Resume Next
    Set myRange = sheet.Cells(rowIndex, colIndex)
    ' ����(rowIndex,colIndex)�ɃZ�������݂��Ă��Ȃ������炱����Error����������
    ' ������On Error Resume Next�Ə����Ă���̂ŁA���̍s�ɐi�ށB
    t = myRange.Value
    ' t�ɋ󂶂�Ȃ�����������΂Ȃɂ��݂����Ƃ݂Ȃ��B
    ' t���󕶎��Ȃ�΂Ȃɂ����������Ƃ݂Ȃ�
    On Error GoTo 0
    ' Resume Next���������Ă���
    If t <> "" Then
        ISheetAccessor_CellExists = True
    Else
        ISheetAccessor_CellExists = False
    End If
End Function




