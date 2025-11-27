package org.example;

import org.jetbrains.annotations.NotNull;

public interface Add<Self> extends Expr<Self> {
    @NotNull Self add(@NotNull Self lhs, @NotNull Self rhs);
}