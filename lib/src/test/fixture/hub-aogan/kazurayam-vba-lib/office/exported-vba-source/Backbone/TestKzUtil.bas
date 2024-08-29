Attribute VB_Name = "TestKzUtil"
Option Explicit
Option Private Module

'@TestModule
'@Folder("Tests")

Private Assert As Object
Private Fakes As Object

'@ModuleInitialize
Private Sub ModuleInitialize()
    'this method runs once per module.
    Set Assert = CreateObject("Rubberduck.AssertClass")
    Set Fakes = CreateObject("Rubberduck.FakesProvider")
End Sub

'@ModuleCleanup
Private Sub ModuleCleanup()
    'this method runs once per module.
    Set Assert = Nothing
    Set Fakes = Nothing
End Sub

'@TestInitialize
Private Sub TestInitialize()
    'This method runs before every test in the module..
End Sub

'@TestCleanup
Private Sub TestCleanup()
    'this method runs after every test in the module.
End Sub

'@TestMethod("KzExistsKey�֐������j�b�g�e�X�g����")
Private Sub Test_KzExistsKey()
    'VBA��Collection�͘A�z�z��̂悤��Key��Item�̃y�A�����ꍇ������
    '�A�z�z��̂悤��Collection���w���Key�������Ă��邩�ǂ����𒲂ׂ�Boolean��Ԃ�
    'Arrange:
    Dim oCol As New Collection
    With oCol
        .Add key:="�e���r", item:="TV"
        .Add key:="�①��", item:="fridge"
        .Add key:="���ъ�", item:="rice cooker"
    End With
    'Assert
    Assert.IsTrue KzExistsKey(oCol, "���ъ�")
    Assert.IsFalse KzExistsKey(oCol, "�����o")
End Sub


'@TestMethod("Function KzVarTypeAsValue�����j�b�g�e�X�g����")
Private Sub Test_KzVarTypeAsString()
    On Error GoTo TestFail
    'Arrange:
    Dim integerVar As Integer: integerVar = 0
    Dim longVar As Long: longVar = 0
    Dim doubleVar As Double: doubleVar = 0
    Dim stringVar As String: stringVar = ""
    Dim booleanVar As Boolean: booleanVar = False
    Dim dateVar As Date: dateVar = Date
    Dim objectVar As Object: Set objectVar = ThisWorkbook
    ' Dim variantVar As Variant: variantVar = "123"
    Dim h() As String
    Dim i() As Integer
    'Act:
    'Assert:
    Assert.AreEqual "Integer", KzVarTypeAsString(integerVar)
    Assert.AreEqual "Long", KzVarTypeAsString(longVar)
    Assert.AreEqual "Double", KzVarTypeAsString(doubleVar)
    Assert.AreEqual "String", KzVarTypeAsString(stringVar)
    Assert.AreEqual "Boolean", KzVarTypeAsString(booleanVar)
    Assert.AreEqual "Date", KzVarTypeAsString(dateVar)
    Assert.AreEqual "Object", KzVarTypeAsString(objectVar)
    ' Assert.AreEqual "Variant", KzVarTypeAsString(variantVar)
    Assert.AreEqual "String()", KzVarTypeAsString(h)
    Assert.AreEqual "Integer()", KzVarTypeAsString(i)
TestExit:
    Exit Sub
TestFail:
    Assert.Fail "Test raised an error: #" & Err.Number & " - " & Err.Description
End Sub