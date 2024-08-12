VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ArrayUtil"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit


' 2�����z���Immediate window�Ƀv�����g����
' �e�����̔z��̍ŏ��Y��������ő�Y�����̊Ԃɂ���v�f���v�����g����
' �����Excel��Range�I�u�W�F�N�g��Value�Ƃ��ĕԂ�2�����z�񂪃C���f�b�N�X1�n�܂�Ƀf�[�^���i�[����A����ɓK���I�ȓ��������
Public Sub PrintArray2D( _
        arr2D As Variant, _
        Optional rowIndex As Long = 0, _
        Optional colLeft As Long = 0)
    
    Dim rowHeader As String
    Dim buf As String
    Dim h, i, j As Long
    
    '--------------------------------------------------
    Dim topLeft As String
    topLeft = "r\c"
    buf = ""
    For h = LBound(arr2D, 2) To UBound(arr2D, 2)
        buf = buf & colLeft & "+" & h & "|"
    Next h
    Debug.Print topLeft & "|" & buf
    
    '--------------------------------------------------
    buf = ""
    For i = LBound(arr2D, 1) To UBound(arr2D, 1)
        rowHeader = rowIndex & "+" & i
        For j = LBound(arr2D, 2) To UBound(arr2D, 2)
            buf = buf & arr2D(i, j) & ","
        Next j
        Debug.Print rowHeader & "|" & buf
        buf = ""
    Next i
    
End Sub

' 1�����z���Immediate window�Ƀv�����g����
' �������z��̃C���f�b�N�X0���為��Ԃ̗v�f���v�����g����
Public Sub PrintArray1D(arr1D As Variant)
    Dim buf As String
    Dim i As Long
    buf = ""
    For i = LBound(arr1D) To UBound(arr1D)
        If Len(buf) > 0 Then
            buf = buf & "|"
        End If
        buf = buf & i
    Next i
    Debug.Print buf
    '-----------------------------------------------
    buf = ""
    For i = LBound(arr1D) To UBound(arr1D)
        If i > LBound(arr1D) Then
            buf = buf & ","
        End If
        buf = buf & arr1D(i)
    Next i
    Debug.Print buf
End Sub


