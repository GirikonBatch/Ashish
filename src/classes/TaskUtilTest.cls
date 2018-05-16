@istest
private class TaskUtilTest {
    @isTest static void test1(){
        string p = TaskUtil.getTaskPriority('a');
        System.assertEquals('Normal', p);
    }
    
     @isTest static void test2(){
        string p = TaskUtil.getTaskPriority('ca');
        System.assertEquals('High', p);
    }
      @isTest static void test3(){
        string p = TaskUtil.getTaskPriority('c6546a');
        System.assertEquals('NULL', p);
    }
}