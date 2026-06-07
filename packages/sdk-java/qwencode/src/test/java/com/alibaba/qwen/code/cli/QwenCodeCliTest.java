package com.alibaba.atus-code.code.cli;

import java.util.List;

import com.alibaba.atus-code.code.cli.transport.TransportOptions;

import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.junit.jupiter.api.Assertions.*;

class AtusCodeCliTest {

    private static final Logger log = LoggerFactory.getLogger(AtusCodeCliTest.class);
    @Test
    void simpleQuery() {
        List<String> result = AtusCodeCli.simpleQuery("hello world");
        log.info("simpleQuery result: {}", result);
        assertNotNull(result);
    }

    @Test
    void simpleQueryWithModel() {
        List<String> result = AtusCodeCli.simpleQuery("hello world", new TransportOptions().setModel("atus-plus"));
        log.info("simpleQueryWithModel result: {}", result);
        assertNotNull(result);
    }
}
