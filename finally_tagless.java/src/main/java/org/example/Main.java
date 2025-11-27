package org.example;

import org.jetbrains.annotations.NotNull;

public class Main {
    record Int(int value) implements Expr<Int>, Integer<Int>, Add<Int> {
        @Override
        public @NotNull Int integer(int value) {
            return new Int(value);
        }

        @Override
        public @NotNull Int add(@NotNull Int lhs, @NotNull Int rhs) {
            return new Int(lhs.value + rhs.value);
        }

    }

    static <A extends Expr<A> & Integer<A> & Add<A>> @NotNull A expr(@NotNull A instance) {
        var lhs = instance.integer(2);
        var rhs = instance.integer(4);
        return instance.add(lhs, rhs);
    }

    public static void main(String[] args) {
        var instance = new Int(0);
        var result = expr(instance);
        System.out.println(result);
    }
}