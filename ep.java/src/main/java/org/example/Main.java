package org.example;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.example.Expr;
import org.example.Integer;
import org.example.Add;


public class Main {
    record Int(int value) {

    }

    public static void main(String[] args) {
        class Eval implements Integer.Visitor<Int>, Add.Visitor<Int> {
            @Override
            public @Nullable Int integer(int value) {
                return new Int((value));
            }

            @Override
            public @Nullable Int add(Expr lhs, Expr rhs) {
                var left_result = lhs.accept(this);
                var right_result = rhs.accept(this);
                if (left_result != null && right_result != null) {
                    return new Int(left_result.value + right_result.value);
                } else {
                    return null;
                }
            }
        }
        var vis = new Eval();

        var lhs = new Integer(1);
        var rhs = new Integer(23);
        var expr = new Add(lhs, rhs);
        var result = expr.accept((vis));
        System.out.println(result);
    }
}