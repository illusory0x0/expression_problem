package org.example;

import org.jetbrains.annotations.NotNull;

public interface Integer<Self> extends Expr<Self> {
    @NotNull Self integer(int value);
}
