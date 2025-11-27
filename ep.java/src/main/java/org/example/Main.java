package org.example;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;



public class Main {

    interface Expr {
        interface Visitor<A> {
        }

        <A> @Nullable A accept(@NotNull Expr.Visitor<A> visitor);
    }

    record Integer(int value) implements Expr {
        interface Visitor<A> extends Expr.Visitor<A> {
            @Nullable A integer(int value);
        }

        @Override
        public <A> @Nullable A accept(Expr.@NotNull Visitor<A> visitor) {
            if (visitor instanceof Visitor<A>) {
                return ((Visitor<A>) visitor).integer(this.value);
            } else {
                return null;
            }
        }
    }

    record Add(Expr lhs, Expr rhs) implements Expr {
        interface Visitor<A> extends Expr.Visitor<A> {
            @Nullable A add(Expr lhs, Expr rhs);
        }

        @Override
        public <A> @Nullable A accept(Expr.@NotNull Visitor<A> visitor) {
            if (visitor instanceof Visitor<A>) {
                return ((Visitor<A>) visitor).add(this.lhs, this.rhs);
            } else {
                return null;
            }
        }
    }

    public static void main(String[] args) {
        class Eval implements Integer.Visitor<Integer>, Add.Visitor<Integer> {
            @Override
            public @Nullable Integer integer(int value) {
                return new Integer((value));
            }

            @Override
            public @Nullable Integer add(Expr lhs, Expr rhs) {
                var left_result = lhs.accept(this);
                var right_result = rhs.accept(this);
                if (left_result != null && right_result != null) {
                    return new Integer(left_result.value + right_result.value);
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