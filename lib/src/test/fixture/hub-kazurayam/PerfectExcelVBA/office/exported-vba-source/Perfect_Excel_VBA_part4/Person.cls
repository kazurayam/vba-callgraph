VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Person"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'Person�N���X

Public ID As Long
Public Name As String
Public Gender As String
Public Birthday As Date
Public Active As Boolean

'**
'* Person�N���X�̃C���X�^���X�ɏ����l��ݒ肷��
'*
'* @param myRange {Range} �ݒ肷�郌�R�[�h�̃Z���͈�
'*
Public Sub Initialize(ByVal aRange As Range)
    ID = aRange(eFields.eId).value
    Name = aRange(eFields.eName).value
    Gender = aRange(eFields.eGender).value
    Birthday = aRange(eFields.eBirthday).value
    Active = aRange(eFields.eActive).value
End Sub

Public Sub Construct(ByVal anID As Long, _
                        ByVal aName As String, _
                        ByVal aGender As String, _
                        ByVal aBirthday As Date, _
                        ByVal isActive As Boolean)
    ID = anID
    Name = aName
    Gender = aGender
    Birthday = aBirthday
    Active = isActive
End Sub

'**
'* Person�I�u�W�F�N�g�̔N����擾����
'*
'* @return {Long} �N��
'*
Public Property Get Age() As Long
    Dim myAge As Long
    '�����_�̓��t��Birthday�v���p�e�B�́u�N�v�̍����Ƃ�
    myAge = DateDiff("yyyy", Me.Birthday, Date)
    '���������N�̒a�������߂��Ă���ꍇ�Ɩ����߂��Ă��Ȃ��ꍇ�Ƃ�����B
    '���������N�̒a�������߂��Ă�����myAge����1�������炷
    If Date < DateSerial(Year(Now), Month(Me.Birthday), Day(Me.Birthday)) Then
        myAge = myAge - 1
    End If
    Age = myAge
End Property