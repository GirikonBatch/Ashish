public class TaskUtil {
    public static String getTaskPriority(String lState) {
      
        if (String.isBlank(lState) || lState.length() > 2) {
            return null;
        }
            
        String taskPriority;
        
        if (lState == 'CA') {
             taskPriority = 'High'; 
        } else {
             taskPriority = 'Normal';
        }
        
        return taskPriority;
    }
}