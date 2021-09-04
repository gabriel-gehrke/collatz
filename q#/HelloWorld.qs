namespace HelloWorld {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation HelloQuantum() : Result
    {
        Message("Hello Quantum-World!");

        using (q = Qubit())
        {
            H(q);
            return M(q);
        }
    }

}
