package org.example;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

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