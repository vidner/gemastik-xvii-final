import MarketplaceListing from '@/pages/marketplace-lisiting'
import { createLazyFileRoute } from '@tanstack/react-router'

export const Route = createLazyFileRoute('/')({
  component: () => <MarketplaceListing />,
})
