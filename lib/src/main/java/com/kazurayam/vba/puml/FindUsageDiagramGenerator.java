package com.kazurayam.vba.puml;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;

public class FindUsageDiagramGenerator {

    private final StringBuilder sb;

    public FindUsageDiagramGenerator() {
        sb = new StringBuilder();
    }

    public void writeStartUml() {
        sb.append("@startuml\n");
        sb.append("left to right direction\n");
    }

    public void writeStartWorkbook(SensibleWorkbook wb) {
        sb.append(String.format("package %s {\n", wb.getId()));
    }

    public void writeStartModule(VBAModule module) {
        if (module.isClass()) {
            sb.append(String.format("  class %s {\n", module.getName()));
        } else if (module.isStandard()) {
            sb.append(String.format("  stereotype %s {\n", module.getName()));
        } else {
            sb.append(String.format("  entity %s {\n", module.getName()));
        }
    }

    public void writeProcedure(VBAModule module, VBAProcedure procedure) {
        sb.append(String.format("    {method} %s\n", procedure.getName()));
    }

    public void writeProcedureReference(VBAProcedureReference procedureReference) {
        sb.append(String.format("%s.%s o-- %s.%s : %s\n",
                procedureReference.getReferrer().getWorkbookId(),
                procedureReference.getReferrer().getModule().getName(),
                procedureReference.getReferee().getWorkbookId(),
                procedureReference.getReferee().getModule().getName(),
                procedureReference.getReferee().getProcedureName()
                )
        );
    }

    public void writeEndModule() {
        sb.append("  }\n");
    }

    public void writeEndWorkbook() {
        sb.append("}\n");
    }

    public void writeEndUml() {
        sb.append("@enduml\n");
    }

    @Override
    public String toString() {
        return sb.toString();
    }

    public void generate(File file) throws IOException {
        this.generate(file.toPath());
    }

    public void generate(Path file) throws IOException {
        Files.writeString(file, sb.toString());
    }

    public void generate(Writer writer) throws IOException {
        BufferedWriter bw = new BufferedWriter(writer);
        bw.write(sb.toString());
        bw.flush();
    }
}