public class TestString {
    public String abbreviate(Integer maxWidth) {
        String s = 'Hello Maximillian';
        String s2 = s.abbreviate(8);
 		System.assertEquals('Hello...', s2);
		System.assertEquals(8, s2.length());
  return null;
    }
}