package org.example;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

public interface Expr {
    interface Visitor<A> {
    }

    <A> @Nullable A accept(@NotNull Expr.Visitor<A> visitor);
}
