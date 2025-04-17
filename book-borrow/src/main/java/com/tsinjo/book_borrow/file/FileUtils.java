package com.tsinjo.book_borrow.file;

import com.tsinjo.book_borrow.book.Book;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;

@Slf4j
public class FileUtils {
    public static byte[] readFileFromLocation(Book book, String fileUrl) {
        if (StringUtils.isBlank(fileUrl)){
            return  null;
        }
        try {
            Path filePath = new File(fileUrl).toPath();
            return Files.readAllBytes(filePath);

        }catch (Exception e){
            log.warn("No file is found in this {}", fileUrl);
        }
        return null;

    }
}
