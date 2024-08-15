package com.kazurayam.vba;

import com.kazurayam.unittest.TestOutputOrganizer;
import com.kazurayam.vbaexample.FindUsageAppFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import java.io.IOException;
import java.nio.file.Path;

import static org.assertj.core.api.Assertions.assertThat;

public class FindUsageAppGrandTest {

    private static final Logger logger =
            LoggerFactory.getLogger(FindUsageAppGrandTest.class);

    private static final TestOutputOrganizer too =
            new TestOutputOrganizer.Builder(FindUsageAppGrandTest.class)
                    .outputDirectoryRelativeToProject("build/tmp/testOutput")
                    .subOutputDirectory(FindUsageAppGrandTest.class)
                    .build();

    private static final Path baseDir =
            too.getProjectDirectory().resolve("src/test/fixture/hub");
    private FindUsageApp app;
    private Path classOutputDir;

    @BeforeTest
    public void beforeTest() throws IOException {
        classOutputDir = too.cleanClassOutputDirectory();
        app = FindUsageAppFactory.createKazurayamSeven();
    }

    @Test
    public void test_writeDiagram_Options_KAZURAYAM() throws IOException {
        Path file = classOutputDir.resolve("test_writeDiagram_Options_KAZURAYAM.pu");
        app.writeDiagram(file);
        assertThat(file).exists();
        assertThat(file.toFile().length()).isGreaterThan(0);
    }
}