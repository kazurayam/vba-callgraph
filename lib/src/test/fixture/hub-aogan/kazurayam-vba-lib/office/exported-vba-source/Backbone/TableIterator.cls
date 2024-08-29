VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TableIterator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' TableIterator�N���X

' ����VBA�ɂ�ListObject�Ƃ����g�ݍ��݃I�u�W�F�N�g������B
' �Ƃ��낪�Y�R�a����VBA�̑f�l�Ȃ̂ŁA�͂���ListObject��m��Ȃ������B
' �K�v�ɔ�����ListObject�̂悤�Ȃ��̂����삵�Ă��܂����B
' ���ꂪTableIterator��ISheetAccessor��SheetAccessor

' Worksheet�̒���Table������ƃC���[�W����B
' Table�Ƃ͈�ԏ�̍s��Header�s�������āAHeader���Ƀf�[�^�̍s������ƂƂ����C���[�W�B
' �f�[�^�̍s��Key��Value�̃y�A�܂�Dictionari�I�u�W�F�N�g�Ƃ��ď��ԂɎ��o�����\�b�h��񋟂���B
' ���̃��\�b�h�̎����������ɉB������Call���̃R�[�h�̌��ʂ����悭���邱�Ƃ�ړI�Ƃ���B
' |||||
' ||name   |address   |age|
' ||Alice  |here      | 16|
' ||Bob    |there     | 23|
' ||Charlie|everywhere|   |
' ||Dave   |          |  6|
' |||||

Dim shAccess As ISheetAccessor
Dim sheet As Worksheet
Dim headerRowIndex As Long  ' 2 in the above example
Dim headerColLeft As Long   ' 2
Dim headerColRight As Long  ' 4
Dim keys() As String        '
Dim dataRowTop As Long      ' 3
Dim dataRowBottom As Long   ' 6

Dim currentRowIndex As Long
Dim arrUtil As ArrayUtil
    
Public Sub Class_Initialize()
    Set shAccess = New SheetAccessor
    Set arrUtil = New ArrayUtil
End Sub

' Worksheet�I�u�W�F�N�g�ƁA���o���s�̍s�ԍ��ƁA���o���s�̊J�n��ԍ���Call�����^����B
' ���o���s�Ɋ܂܂��Key�̏W����Initialize���T�������B
' ���o���s��1�s�����ł��邱�Ƃ��ÖٓI�ɑO�񂷂�B
' ���o���s�̎�����f�[�^�s���n�܂�ƑO�񂷂�B
' �f�[�^�s���S���ł������邩��Initialize���T���o���B
Public Sub Initialize( _
        ByVal sheet_ As Worksheet, _
        ByVal headerRowIndex_ As Long, _
        ByVal headerColLeft_ As Long)
    Set sheet = sheet_
    headerRowIndex = headerRowIndex_
    headerColLeft = headerColLeft_
    headerColRight = shAccess.FindLastColumn(sheet, headerRowIndex, headerColLeft)
    
    'Debug.Print "sheet.Name=" & sheet.Name
    'Debug.Print "headerRowIndex=" & headerRowIndex
    'Debug.Print "headerColLeft=" & headerColLeft
    'Debug.Print "headerColRight=" & headerColRight
    
    keys = shAccess.ReadSingleRow(sheet, headerRowIndex, headerColLeft, headerColRight)
    
    ' for �f�o�b�O
    Call arrUtil.PrintArray1D(keys)
    
    dataRowTop = headerRowIndex + 1
    dataRowBottom = shAccess.GetRowBottom(sheet, headerColLeft)
    currentRowIndex = dataRowTop
End Sub

' Caller��TableIterator�C���X�^���X��NextDictionary()���\�b�h��
' 1��Call���邽�т�NextDictionary()���\�b�h�͎��̃f�[�^�s1��
' Dictionary�I�u�W�F�N�g�ɕϊ����ĕԂ��B
' Caller��NextDictionary()���ĂԑO��HasNext()���\�b�h���Ă��
' True���Ԃ��Ă��邱�Ƃ��m���߂�ׂ��ł���B
' ���ׂẴf�[�^�s����舵�������Ƃł����Call���ꂽ��NextDictionary()
' �͌x�����b�Z�[�W��\�����A���ʂƂ��ċ��Dictionary��Ԃ��B
Public Function NextDictionary() As Dictionary
    Dim i As Integer
    If HasNext() = True Then
        
        Dim dict As Dictionary: Set dict = New Dictionary
        For i = LBound(keys) To UBound(keys)
            
            'Debug.Print "currentRowIndex=" & currentRowIndex & _
            '            ", i=" & i & _
            '            ", key=" & keys(i) & _
            '            ", value=" & shAccess.GetCellValue(sheet, currentRowIndex, 1 + i)
            
            If keys(i) <> "" Then
                If Not dict.Exists(keys(i)) Then
                    dict.Add keys(i), shAccess.GetCellValue(sheet, currentRowIndex, 2 + i) ' �Ȃ��1+i���Ƃ����ƁAkeys�z��̓Y����1�Ŏn�܂邩��
                Else
                    ' ����key��2��ȏ㌻�ꂽ���̂ق����̗p����̂ق��𖳎�����
                End If
            End If
        Next i
        
        ' increment the index
        currentRowIndex = currentRowIndex + 1
        
        Set NextDictionary = dict
    Else
        Debug.Print "HasNext() returned False"
        Set NextDictionary = New Dictionary
    End If
End Function

' ����NextDictionary()���\�b�h���Ă΂ꂽ�Ƃ��ɗL�ӂȃf�[�^��Ԃ����ԂȂ��HasNext()��True��Ԃ��B
' �����Ȃ���΁i�܂�����ŏI�̃f�[�^�܂ŏ����ς݂Ȃ�΁jHasNext()��False��Ԃ��B
Public Function HasNext() As Boolean
    If currentRowIndex <= dataRowBottom Then
        HasNext = True
    Else
        HasNext = False
    End If
End Function



