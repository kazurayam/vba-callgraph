package com.kazurayam.vba;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

public class SensibleWorkbook {

    private final String id;
    private final Path workbookPath;
    private final Path sourceDirPath;
    private final SortedMap<String, VBAModule> modules;

    private static final String SHEET_NAME = "プロシージャ一覧";
    private final static ObjectMapper mapper;

    static {
        mapper = new ObjectMapper();
        SimpleModule module = new SimpleModule();
        module.addSerializer(SensibleWorkbook.class, new SensibleWorkbookSerializer());
        module.addSerializer(VBAModule.class, new VBAModule.VBAModuleSerializer());
        mapper.registerModule(module);
    }

    public SensibleWorkbook(String id, Path workbookPath, Path sourceDirPath) throws IOException {
        this.id = id;
        this.workbookPath = workbookPath;
        this.sourceDirPath = sourceDirPath;
        InputStream is = Files.newInputStream(workbookPath);
        modules = this.loadModules(is);
    }

    public String getId() {
        return id;
    }

    public Path getWorkbookPath() {
        return workbookPath;
    }

    public Path getSourceDirPath() {
        return sourceDirPath;
    }

    public boolean containsKey(String name) {
        return modules.containsKey(name);
    }

    public SortedMap<String, VBAModule> getModules() {
        return this.modules;
    }

    public Set<String> keySet() {
        return modules.keySet();
    }

    public VBAModule getModule(String name) {
        if (modules.containsKey(name)) {
            return modules.get(name);
        } else {
            throw new IllegalArgumentException("VBAModule named " + name + " is not found");
        }
    }

    SortedMap<String, VBAModule> loadModules(InputStream inputStream) throws IOException {
        SortedMap<String, VBAModule> modules = new TreeMap<>();
        org.apache.poi.ss.usermodel.Workbook wb = new XSSFWorkbook(inputStream);
        Sheet sheet = wb.getSheet(SHEET_NAME);
        for (Row row : sheet) {
            if (row.getRowNum() > 0) { // we will skip the first row = header
                String name = row.getCell(0, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL).getStringCellValue();
                String module = row.getCell(1, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL).getStringCellValue();
                String scope = row.getCell(2, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL).getStringCellValue();
                String subOrFunc = row.getCell(3, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL).getStringCellValue();
                double dvalue = row.getCell(4, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL).getNumericCellValue();
                Integer lineNo = ((Double)dvalue).intValue();
                String source = row.getCell(5, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL).getStringCellValue();
                String comment = row.getCell(6, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL).getStringCellValue();
                VBAProcedure proc =
                        new VBAProcedure.Builder()
                                .name(name)
                                .module(module)
                                .scope(VBAProcedure.Scope.valueOf(scope))
                                .subOrFunc(VBAProcedure.SubOrFunc.valueOf(subOrFunc))
                                .source(source)
                                .comment(comment)
                                .build();
                //
                VBAModule vbaModule;
                if (!modules.containsKey(module)) {
                    vbaModule = new VBAModule(module);
                } else {
                    vbaModule = modules.get(module);
                }
                vbaModule.add(proc);
                modules.put(module, vbaModule);
            }
        }
        return modules;
    }

    @Override
    public String toString() {
        //pretty print
        try {
            Object json = mapper.readValue(this.toJson(), Object.class);
            return mapper.writerWithDefaultPrettyPrinter().writeValueAsString(json);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public String toJson() throws JsonProcessingException {
        // without indent
        return mapper.writeValueAsString(this);
    }


    /**
     *
     */
    public static class SensibleWorkbookSerializer extends StdSerializer<SensibleWorkbook> {
        public SensibleWorkbookSerializer() { this(null); }
        public SensibleWorkbookSerializer(Class<SensibleWorkbook> t) { super(t); }
        @Override
        public void serialize(
                SensibleWorkbook wb, JsonGenerator jgen, SerializerProvider provider)
                throws IOException {
            jgen.writeStartObject();
            jgen.writeStringField("id", wb.getId());
            jgen.writeStringField("workbookPath", wb.getWorkbookPath().toString());
            jgen.writeStringField("sourceDirPath", wb.getSourceDirPath().toString());
            jgen.writeArrayFieldStart("modules");
            for (String name : wb.getModules().keySet()) {
                jgen.writeObject(wb.getModule(name));
            }
            jgen.writeEndArray();
            jgen.writeEndObject();
        }
    }
}