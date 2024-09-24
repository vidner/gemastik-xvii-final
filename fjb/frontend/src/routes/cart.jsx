import CartCheckout from '@/pages/cart-checkout'
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/cart')({
  component: () => <CartCheckout />,
})
