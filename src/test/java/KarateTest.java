import com.intuit.karate.junit5.Karate;

class KarateTest {
    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:karate-test.feature");
    }
}
