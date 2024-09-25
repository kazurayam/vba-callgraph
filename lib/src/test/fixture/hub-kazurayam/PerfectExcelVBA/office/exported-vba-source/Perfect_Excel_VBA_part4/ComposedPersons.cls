VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ComposedPersons"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'**
'* The container of a Collection of Person objects equipped with various
'* accessor methods: LoadData, ApplyData, AddPerson, UpdatePerson
'*

Public Enum eFields
    eId = 1
    eName
    eGender
    eBirthday
    eActive
End Enum

'����̃f�[�^�����^���ꂽ���[�N�V�[�g
Private baseSheet As Worksheet

'Worksheet�̒��̃e�[�u���A���Ȃ킿����͂��ꂽ�f�[�^�̌�
Private table As ListObject

'ID��key�Ƃ�Person�I�u�W�F�N�g��value�Ƃ���
'key��Long�^�ł���B
'�� 1,2,3,4,...
Public persons As Dictionary

'persons�Ɋi�[�ς݂�ID�̂����ł��傫�Ȓl
'����Person�I�u�W�F�N�g��ǉ�����Ƃ�����ID��MaxId+1�ƂȂ�
Public MaxId As Long

Private logger As BbLogger

'**
'* ����MemberSheetImpl�I�u�W�F�N�g������������B���Ȃ킿
'* 1. originTable�ւ̎Q�Ƃ��L����
'* 2. persons�R���N�V������New����
'* 3. originTable�̍s��Person�I�u�W�F�N�g�ɕϊ�����persons�Ɋi�[��
'* 4. persons�R���N�V�����̃T�C�Y��MaxId�ɋL�����Ă���
'*
Public Sub Initialize(ByRef ws As Worksheet)
    Set logger = BbLoggerFactory.CreateLogger("ComposedPersons")
    logger.procedureName = "Initialize"
    '
    Set baseSheet = ws
    Set table = baseSheet.ListObjects(1)
    Set persons = New Dictionary
    MaxId = 0
    'logger.Info "Initialized with Sheet:", ws.Name
End Sub

'**
'* �^����ꂽListObjects�̃f�[�^��Persons�R���N�V�����Ɋi�[����
'*
Public Function LoadData() As Long
    logger.procedureName = "LoadData"
    '
    If table.ListRows.Count = 0 Then
        With err
            .Clear
            .Raise vbObjectError + 513, "ComposedPersons.Initialize", _
                "�^����ꂽ�V�[�g�̃e�[�u��������ۂł����B�^�����V�[�g����������Ԃ��ǂ����m���߂Ă��������B"
        End With
    End If
    '
    With table
        'logger.Info "table.ListRows.Count", .ListRows.Count
        Dim aRow As ListRow
        For Each aRow In .ListRows
            Dim aPerson As Person: Set aPerson = New Person
            aPerson.Initialize aRow.Range
            'Person�I�u�W�F�N�g��ID�v���p�e�B�iLong�^�j��key�Ƃ���
            'Person�I�u�W�F�N�g��Dictionary�Ɋi�[����
            persons.Add aPerson.ID, aPerson
            '
            If MaxId < aPerson.ID Then
                'persons�Ɋi�[���ꂽPerson�I�u�W�F�N�g��ID�̍ő�l���o���Ă���
                MaxId = aPerson.ID
            End If
            'logger.Info "MaxId", MaxId, "aPerson.ID", aPerson.ID
        Next aRow
    End With
    LoadData = MaxId
    Exit Function
    
ErrorHandler:
    With err
        Dim title As String: title = "�G���[���������܂���"
        Dim m As String: m = ""
        m = m & "�G���[�ԍ�:" & .number & vbNewLine
        m = m & "���e:" & .Description & vbNewLine
        MsgBox m, vbExclamation, title
        LoadData = 0
        Exit Function
    End With
End Function

'**
'* ���݂�Persons�R���N�V�����̓��e���w�肳�ꂽListObject�̂Ȃ��ɕۑ�����
'*
Public Sub ApplyData()

    '�V�[�g�̕ی���ꎞ�I�ɉ�������
    If baseSheet.ProtectContents Then
        baseSheet.Unprotect Relay.sheetPW
    End If
    
    '�e�[�u����AutoFilter����������
    table.ShowAutoFilter = False
    
    With table
        '�o�͐�̃��[�N�V�[�g�̂Ȃ��̃e�[�u���������������ۂɂ���
        If .ListRows.Count > 0 Then
            .DataBodyRange.EntireRow.Delete
        End If
        
        'persons�f�B�N�V���i���̓��e���V�[�g�̂Ȃ��̃e�[�u���ɏ������݂�����
        '�p�t�H�[�}���X��ǂ����邽�ߏ���������Bpersons��2�����z��ɒ����B
        Dim values() As Variant: ReDim values(1 To MaxId, 1 To 5)
        
        Dim aKey As Variant
        For Each aKey In persons
            Dim p As Person: Set p = persons.Item(aKey)
            values(p.ID, eId) = p.ID
            values(p.ID, eName) = p.Name
            values(p.ID, eGender) = p.Gender
            values(p.ID, eBirthday) = p.Birthday
            values(p.ID, eActive) = p.Active
        Next aKey
        
        Dim baseRange As Range: Set baseRange = .Range(1, 1).Offset(1)
        baseRange.Resize(MaxId, 5).value = values
        
    End With
    
    '�V�[�g��AutoFilter��K�p����
    table.ShowAutoFilter = True
    
    '�V�[�g��ی삷��
    baseSheet.Protect Relay.sheetPW, AllowFiltering:=True
End Sub

'**
'* Persons�f�B�N�V���i���Ɋ܂܂ꂽPerson�I�u�W�F�N�g��ID�̔z���Ԃ��B
'* Person�I�u�W�F�N�g��ID��Long�^�B�����String�^�ɕϊ�����Variant�^�z���Ԃ��B
'* ���Ƃ��� Array("1", "2", "3", ...) �Ɠ����B
'* UserForm1�����p���邱�Ƃ�z�肵�Ă���B
'*
Public Function GetIdList() As Variant
    GetIdList = persons.Keys()
End Function

'**
'* ����aPerson�Ƃ��ė^����ꂽPerson�I�u�W�F�N�g��persons�f�B�N�V���i���̂Ȃ���
'* �������݁A�����[�N�V�[�g�̃e�[�u���ɂ����f����B
'* ����aPerson�Ƃ��ė^����ꂽPerson�I�u�W�F�N�g��persons�f�B�N�V���i���̂Ȃ���
'* ���łɑ��݂��Ă���ꍇ�ƁA�܂����݂��Ă��Ȃ��ꍇ�Ɠ�ʂ肠�肤��B
'* �ǂ���̏ꍇ�ł�OK�B
'* ���łɑ��݂��Ă����ꍇ�ɂ�aPerson�̓��e�Ńf�B�N�V���i����Value��u��������B
'* �܂����݂��Ă��Ȃ������ꍇ�ɂ͌��ʓI��aPerson���f�B�N�V���i���ɒǉ�����B
'*
'* @param aPerson {Person} Person object to update
'*
Public Sub UpdatePerson(ByVal aPerson As Person)
    If persons.Exists(aPerson.ID) Then
        With persons.Item(aPerson.ID)
            .ID = aPerson.ID
            .Name = aPerson.Name
            .Gender = aPerson.Gender
            .Birthday = aPerson.Birthday
            .Active = aPerson.Active
        End With
    Else
        Dim newPerson As Person: Set newPerson = New Person
        With newPerson
            .ID = aPerson.ID
            .Name = aPerson.Name
            .Gender = aPerson.Gender
            .Birthday = aPerson.Birthday
            .Active = aPerson.Active
        End With
        persons.Add aPerson.ID, newPerson
        MaxId = MaxId + 1
    End If
    Call ApplyData
End Sub

Public Function Exists(ByVal anID As String) As Boolean
    Exists = persons.Exists(CLng(anID))
End Function

'**
'* �u����v�V�[�g��B1�Z����pinterCell�p�����[�^�Ƃ��ė^����ꂽ�Ƃ���B
'* B1�Z����Value�� "$D$14" �Ƃ���������ł������Ƃ���B
'* $D$14�Z����persons�f�B�N�V���i���̂ǂ̃��R�[�h�ɑΉ����邩�����Z�ŋ��߂�B
'* �����Łu�Ή�����v�Ƃ�$D$14�Z���̃f�[�^��Person�I�u�W�F�N�gX�̃f�[�^�ł���Ƃ������ƁB
'* �Ȃ��Z���̗�ԍ�$D�𖳎����čs�ԍ�$14������Person�I�u�W�F�N�g�Ƃ̑Ή��֌W�𔻒肷��B
'* �������ꂽPerson�I�u�W�F�N�g���֐��̒l�Ƃ��ĕԂ��B
'* �������^����ꂽ�p�����[�^�ɑΉ�����Person������ł��Ȃ�������Nothing��Ԃ��B
'*
Public Function InterpreteSelectedRangeToPerson(ByRef pointerCell As Range) As Person
    logger.procedureName = "InterpreteSelectedRangeToPerson"
    'logger.Info "pointerCell.Value", pointerCell.value
    'logger.Info "persons.Count", persons.Count
    '
    Dim pointedCell As Range
    Set pointedCell = baseSheet.Range(pointerCell.value)
    'logger.Info "pointedCell.Row", pointedCell.Row
    'logger.Info "table.DataBodyRange.Address", table.DataBodyRange.Address
    'logger.Info "table.DataBodyRange.Row", table.DataBodyRange.Row
    '
    Dim personId As Long
    personId = pointedCell.Row - table.DataBodyRange.Row + 1
    'logger.Info "personId", personId
    '
    If 0 < personId And personId <= MaxId Then
        Set InterpreteSelectedRangeToPerson = persons.Item(personId)
    Else
        Set InterpreteSelectedRangeToPerson = Nothing
    End If
End Function

