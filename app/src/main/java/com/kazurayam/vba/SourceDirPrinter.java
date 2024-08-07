package com.kazurayam.vba;

import com.kazurayam.unittest.TestOutputOrganizer;
import com.kazurayam.vbaexample.MyWorkbook;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

public class SourceDirPrinter {

    private final List<SensibleWorkbook> workbookList;

    public SourceDirPrinter() {
         workbookList = new ArrayList<>();
    }

    public void add(SensibleWorkbook workbook) {
        workbookList.add(workbook);
    }

    public void printAllSourceDirs(Writer writer) throws IOException {
        BufferedWriter bw = new BufferedWriter(writer);
        for (SensibleWorkbook wb : workbookList) {
            SourceDirVisitor visitor =
                    new SourceDirVisitor();
            Files.walkFileTree(wb.getSourceDirPath(), visitor);
            List<Path> sources = visitor.getList();
            this.printSourceDir(wb, sources, bw);
            bw.write("\n\n");
        }
        bw.flush();
        bw.close();
    }

    public void printSourceDir(SensibleWorkbook wb,
                               List<Path> sources,
                               Writer writer) {
        PrintWriter pw = new PrintWriter(new BufferedWriter(writer));
        pw.println("### " + wb.getId());
        pw.println("|No.|file name|");
        pw.println("|--:|:--------|");
        List<String> sortedFileNames =
                sources.stream()
                        .map(p -> p.getFileName().toString())
                        .sorted()
                        .toList();
        for (int i = 0; i < sortedFileNames.size(); i++) {
            pw.println(String.format("|%d|%s|", i+1, sortedFileNames.get(i)));
        }
        pw.flush();
    }

    public static void main(String[] args) throws IOException {
        TestOutputOrganizer too =
                new TestOutputOrganizer.Builder(SourceDirPrinter.class)
                        .subOutputDirectory(SourceDirPrinter.class)
                        .build();
        Path baseDir = too.getProjectDirectory().resolve("../../../github-aogan");
        SourceDirPrinter printer = new SourceDirPrinter();
        printer.add(new SensibleWorkbook(
                MyWorkbook.Backbone.getId(),
                MyWorkbook.Backbone.resolveWorkbookUnder(baseDir),
                MyWorkbook.Backbone.resolveSourceDirUnder(baseDir)));
        printer.add(new SensibleWorkbook(
                MyWorkbook.Member.getId(),
                MyWorkbook.Member.resolveWorkbookUnder(baseDir),
                MyWorkbook.Member.resolveSourceDirUnder(baseDir)));
        printer.add(new SensibleWorkbook(
                MyWorkbook.Cashbook.getId(),
                MyWorkbook.Cashbook.resolveWorkbookUnder(baseDir),
                MyWorkbook.Cashbook.resolveSourceDirUnder(baseDir)));
        printer.add(new SensibleWorkbook(
                MyWorkbook.Settlement.getId(),
                MyWorkbook.Settlement.resolveWorkbookUnder(baseDir),
                MyWorkbook.Settlement.resolveSourceDirUnder(baseDir)));
        printer.add(new SensibleWorkbook(
                MyWorkbook.FeePaymentCheck.getId(),
                MyWorkbook.FeePaymentCheck.resolveWorkbookUnder(baseDir),
                MyWorkbook.FeePaymentCheck.resolveSourceDirUnder(baseDir)));
        printer.add(new SensibleWorkbook(
                MyWorkbook.PleasePayFeeLetter.getId(),
                MyWorkbook.PleasePayFeeLetter.resolveWorkbookUnder(baseDir),
                MyWorkbook.PleasePayFeeLetter.resolveSourceDirUnder(baseDir)));
        printer.add(new SensibleWorkbook(
                MyWorkbook.WebCredentials.getId(),
                MyWorkbook.WebCredentials.resolveWorkbookUnder(baseDir),
                MyWorkbook.WebCredentials.resolveSourceDirUnder(baseDir)));

        Path report = too.getProjectDirectory().resolve("../../docs/MyVBASourceDirs.md");
        assert Files.exists(report.getParent());
        Writer writer = Files.newBufferedWriter(report);
        printer.printAllSourceDirs(writer);
    }
}