package controller;

import java.util.Date;

public class SavingsGoalValidator {

    public boolean validateGoalName(String name) {
        return name != null && !name.trim().isEmpty() && name.length() <= 100;
    }

    public boolean validateTargetAmount(String targetAmountStr) {
        try {
            double amt = Double.parseDouble(targetAmountStr);
            return amt > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public boolean validateTargetDate(Date date) {
        if (date == null)
            return true; // optional
        return date.after(new Date());
    }
}
