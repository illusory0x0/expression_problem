package org.example;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

public record Integer(int value) implements Expr {
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