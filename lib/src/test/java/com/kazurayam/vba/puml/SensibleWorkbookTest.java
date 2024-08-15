package com.kazurayam.vba.puml;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.kazurayam.unittest.TestOutputOrganizer;
import com.kazurayam.vba.example.MyWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.SortedMap;
import java.util.SortedSet;

import static org.assertj.core.api.Assertions.assertThat;

public class SensibleWorkbookTest {

    private static final Logger logger = LoggerFactory.getLogger(SensibleWorkbookTest.class);
    private static final TestOutputOrganizer too =
            new TestOutputOrganizer.Builder(SensibleWorkbookTest.class)
                    .outputDirectoryRelativeToProject("build/tmp/testOutput")
                    .subOutputDirectory(SensibleWorkbookTest.class)
                    .build();
    private static final Path baseDir =
            too.getProjectDirectory().resolve("src/test/fixture/hub");
    private SensibleWorkbook wb;
    private Path classOutputDir;

    @BeforeTest
    public void beforeTest() throws IOException {
        wb = new SensibleWorkbook(
                MyWorkbook.Cashbook.getId(),
                MyWorkbook.Cashbook.resolveWorkbookUnder(baseDir),
                MyWorkbook.Cashbook.resolveSourceDirUnder(baseDir));
        classOutputDir = too.cleanClassOutputDirectory();
    }
    @Test
    public void test_Cashbook_isNotNull() {
        assertThat(wb).isNotNull();
    }

    @Test
    public void test_toJson() throws JsonProcessingException {
        String json = wb.toJson();
        assertThat(json).isNotNull();
        logger.info("[test_toJson] " + json);
        assertThat(json).contains("id");
        assertThat(json).contains("Cashbook");
        assertThat(json).contains("workbookPath");
        assertThat(json).contains("sourceDirPath");
    }

    @Test
    public void test_toString() throws IOException {
        String json = wb.toString();
        assertThat(json).isNotNull();
        logger.info("[test_toString] " + json);
        assertThat(json).contains("id");
        assertThat(json).contains("Cashbook");
        assertThat(json).contains("workbookPath");
        assertThat(json).contains("sourceDirPath");
        Path outFile = classOutputDir.resolve("test_toString.json");
        Files.writeString(outFile, json);
    }

    @Test
    public void test_getModules() throws IOException {
        SensibleWorkbook wb = new SensibleWorkbook(
                MyWorkbook.Member.getId(),
                MyWorkbook.Member.resolveWorkbookUnder(baseDir),
                MyWorkbook.Member.resolveSourceDirUnder(baseDir));
        SortedMap<String, VBAModule> modules =
                wb.getModules();
        assertThat(modules.keySet().size()).isEqualTo(3);
    }

    @Test
    public void test_injectSourceIntoModules() throws IOException {
        SortedMap<String, VBAModule> modules = wb.getModules();
        Path sourceDirPath = wb.getSourceDirPath();
        SensibleWorkbook.injectSourceIntoModules(modules, sourceDirPath);
        for (VBAModule module : modules.values()) {
            assertThat(module.getVBASource())
                    .as("asserting VBAModule \"%s\".getVBASource()", module.getName())
                    .isNotNull();
            assertThat(module.getVBASource().getSourcePath()).exists();
        }
    }

    @Test
    public void test_getAllFullyQualifiedProcedureId() {
        SortedSet<FullyQualifiedVBAProcedureId> memo =
                wb.getAllFullyQualifiedProcedureId();
        assertThat(memo).isNotNull();
        assertThat(memo.size()).isEqualTo(131);
    }
}