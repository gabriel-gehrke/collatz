import java.math.BigInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Consumer;
import java.util.stream.IntStream;

public class Collatz {

    private static final BigInteger THREE = BigInteger.valueOf(3);
    private static BigIntConsumer DO_NOTHING = (val) -> {};

    public static void main(String[] args) {

        if (args.length == 0) {

            AtomicReference<BigInteger> maxValue = new AtomicReference<>(BigInteger.ONE);
            AtomicReference<BigInteger> maxLength = new AtomicReference<>(BigInteger.ONE);

            final var maxValAccumulator = new BigIntMaxAccumulator(maxValue, val -> System.out.println("New Maximum Value: " + val));
            final var maxLengthAccumulator = new BigIntMaxAccumulator(maxLength, val -> System.out.println("New Maximum Length: " + val));

            BigInteger value = BigInteger.ONE;

            for (;;) {
                collatz(value, DO_NOTHING, maxValAccumulator, maxLengthAccumulator);
                value = value.add(BigInteger.ONE);
            }

        } else if (args.length == 1) {
            // base 10
            collatz(new BigInteger(args[0], 10));
        }

        

    }

    private static void collatz(BigInteger value) {
        collatz(value, System.out::println, DO_NOTHING, DO_NOTHING);
    }

    private static void collatz(BigInteger value, BigIntConsumer stepConsumer, BigIntConsumer maxValueConsumer, BigIntConsumer lengthConsumer) {

        BigInteger max = value;
        BigInteger length = BigInteger.ONE;

        stepConsumer.accept(value);

        while (value.compareTo(BigInteger.ONE) > 0) {
            if (value.testBit(0)) {
                // value is odd
                value = value.multiply(THREE).add(BigInteger.ONE);
            } else {
                // value is even
                value = value.shiftRight(1);
            }

            if (value.compareTo(max) > 0) {
                max = value;
            }
            length = length.add(BigInteger.ONE);

            stepConsumer.accept(value);
        }

        // "output" max value and sequence length
        maxValueConsumer.accept(max);
        lengthConsumer.accept(length);
    }


    private static interface BigIntConsumer extends Consumer<BigInteger> {
        
    }

    private static class BigIntMaxAccumulator implements BigIntConsumer {

        private final AtomicReference<BigInteger> atomic;
        private final BigIntConsumer valueUpdatedEvent;

        public BigIntMaxAccumulator(AtomicReference<BigInteger> atomic, BigIntConsumer valueUpdatedEvent) {
            this.atomic = atomic;
            this.valueUpdatedEvent = valueUpdatedEvent;
        }

        @Override
        public void accept(BigInteger newVal) {
            BigInteger oldVal = atomic.get();
            while (newVal.compareTo(oldVal) > 0) {
                if (!atomic.compareAndSet(oldVal, newVal)) {
                    oldVal = atomic.get();
                } else {
                    valueUpdatedEvent.accept(newVal);
                }
            }
        }
    }

}