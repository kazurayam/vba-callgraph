VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BbDocTransformer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit


' BbDocTransformer Word�����ϊ��@
'
' �e���v���[�g�Ƃ��Ă�Word�t�@�C����ǂ݁A�V����Word�t�@�C���𐶐����ď������ށB
' Excel���[�N�V�[�g�ɏ����ꂽ����i�l�̖��O�Ƃ��̑����j�̂P�s�Ԃ�̃f�[�^����͂Ƃ��Ď󂯎��B
' �e���v���[�g�̒��ɂ���placeholders�i���Ƃ��� ${���O}�j�����[�N�V�[�g����擾�����l�Œu������B
'
' �e���W���[����Excel���[�N�V�[�g���炽�Ƃ���2�O�O�l���̖����ǂ݁A
' DocTransformer��2�O�O��Ăяo���΁AWord�t�@�C����2�O�O�������鏈�������������邱�Ƃ��ł���B
'
' Word�t�@�C����IO���邽�߂�Word.Application�I�u�W�F�N�g��K�v�Ƃ��邪�A�p�t�H�[�}���X���l�����āA
' �e���W���[����Word.Application�I�u�W�F�N�g�𐶐����āAInitialize���\�b�h���Ăяo���ēn�����Ƃ����߂�B
'

Dim wordApp As Word.Application

Public Sub Initialize(wa As Word.Application)
    Set wordApp = wa
End Sub

Public Sub Transform( _
    ByVal TemplateWordFile As String, _
    ByVal KeyValuePairs As Dictionary, _
    ByVal ResultWordFile As String)
    
    Dim key As Variant
    
    ' �e���v���[�g�Ƃ��Ă�Word�t�@�C�������ʂƂ��Ă�Word�t�@�C���փR�s�[
    FileCopy TemplateWordFile, ResultWordFile
    
    ' ���ʂƂ��Ă�Word�t�@�C����open����
    Dim doc As Word.Document: Set doc = wordApp.Documents.Open(ResultWordFile)
    
    ' Word�����̂Ȃ��̃v���[�X�z���_�[��Excel������o�����f�[�^�Œu��������
    Dim KeysArray: KeysArray = KeyValuePairs.keys
    For Each key In KeysArray
        ' Debug.Print Key & "=" & KeyValuePairs.Item(Key)
        Dim placeholder As String: placeholder = "${" & key & "}"
        
        doc.Content.Find.Execute findText:=placeholder, _
                                ReplaceWith:=KeyValuePairs(key), _
                                MatchCase:=True, Replace:=wdReplaceAll
    Next
    
    ' �u�����ʂ��t�@�C���ɕۑ�����
    doc.Save
    
    ' ��n��
    doc.Close   ' Close����̂�Y����
                ' Word.Document�I�u�W�F�N�g��Close��Y���Ǝ�����s����FieCopy�ŃG���[�R�[�h71���������Ď��s����
    Set doc = Nothing
    
End Sub




