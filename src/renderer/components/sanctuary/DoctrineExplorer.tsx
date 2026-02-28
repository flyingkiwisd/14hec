import { useState, useEffect } from 'react'
import type { Page } from '../../App'
import type { Plant } from '../../types'

interface DoctrineExplorerProps {
  navigate: (page: Page) => void
}

interface DoctrineEntry {
  plantName: string
  signature: string
  bodyPart: string
  explanation: string
}

const DOCTRINE_ENTRIES: DoctrineEntry[] = [
  { plantName: 'Mugwort', signature: 'Silver-backed leaves that shimmer like moonlight', bodyPart: 'Pineal gland, dream body', explanation: 'The silvery sheen of mugwort leaves mirrors the moon\'s reflective quality, indicating its power over dreams, intuition, and the subconscious. As the moon governs the night, mugwort governs the dreamscape.' },
  { plantName: 'St. John\'s Wort', signature: 'Bright yellow flowers that bloom at midsummer; translucent dots in leaves', bodyPart: 'Nervous system, mood', explanation: 'The golden flowers reach peak bloom at the summer solstice, the sun\'s apex. Hold a leaf to light and see the translucent oil glands\u2014channels of light. This solar plant brings light to darkness in the nervous system and emotional body.' },
  { plantName: 'Rose', signature: 'Multi-layered petals surrounding a protected center', bodyPart: 'Heart, emotional body', explanation: 'The rose opens in concentric layers, each petal a boundary that can open or close\u2014mirroring the heart\'s capacity for both vulnerability and protection. The thorns guard the bloom, just as healthy boundaries protect the open heart.' },
  { plantName: 'Dandelion', signature: 'Yellow flower resembles the sun; bitter milky sap', bodyPart: 'Liver, gallbladder', explanation: 'The bright yellow flower head mirrors the solar plexus. The bitter, milky latex when the stem is broken points to its liver-stimulating action. Bitterness is the taste of the liver. The deep taproot draws minerals up from the earth, just as the liver draws and processes nutrients.' },
  { plantName: 'Ginger', signature: 'Knotted, joint-like rhizome with warming, fiery interior', bodyPart: 'Joints, digestive fire', explanation: 'The ginger root resembles swollen, inflamed joints\u2014and indeed it is one of the great anti-inflammatory herbs for joint conditions. Cut it open and it reveals a fiery, pungent interior, signaling its ability to kindle digestive fire and warm cold conditions.' },
  { plantName: 'Comfrey', signature: 'Hairy leaves with a slippery, mucilaginous interior', bodyPart: 'Bones, connective tissue', explanation: 'Known as "knitbone," comfrey\'s signature is in its feel: the rough, hairy exterior conceals a slimy, gel-like inner substance. This mirrors how bones (rough, hard exterior) are held together by smooth, mucilaginous connective tissue. The plant literally helps knit bone.' },
  { plantName: 'Passionflower', signature: 'Intricate, mandala-like flower with corona of filaments', bodyPart: 'Nervous system, mind', explanation: 'The extraordinarily complex flower structure\u2014with its radial corona of purple-white filaments\u2014resembles a mandala or a neural network. This visual complexity maps to its action on the nervous system, calming the overactive mind.' },
  { plantName: 'Yarrow', signature: 'Feathery, finely divided leaves; clusters of tiny flowers', bodyPart: 'Blood, wounds', explanation: 'The finely divided leaves resemble blood vessels branching into capillaries. Yarrow\'s ancient name Achillea references Achilles, who used it to staunch battlefield wounds. Its signature is in its ability to both stop bleeding and improve blood flow.' },
  { plantName: 'Nettle', signature: 'Stinging hairs that inject formic acid on contact', bodyPart: 'Blood, iron, inflammation', explanation: 'The sting of the nettle is its signature: a sharp, immediate inflammatory response that paradoxically teaches the body about inflammation. The plant is extraordinarily high in iron (blood-building) and its sting stimulates circulation. The remedy for the sting grows near the sting.' },
  { plantName: 'Reishi', signature: 'Hard, woody shelf fungus with lacquered red-brown surface', bodyPart: 'Immune system, spirit', explanation: 'Reishi\'s hard, enduring form\u2014growing on trees for years\u2014signals longevity and resilience. Its reddish-brown lacquered surface resembles liver tissue, pointing to its liver-protecting actions. Known as the "mushroom of immortality," its very persistence is its doctrine.' }
]

export default function DoctrineExplorer({ navigate }: DoctrineExplorerProps) {
  const [plants, setPlants] = useState<Plant[]>([])
  const [selectedEntry, setSelectedEntry] = useState<DoctrineEntry | null>(null)

  useEffect(() => {
    window.api.getPlants().then(setPlants)
  }, [])

  const findPlantByName = (name: string) => plants.find((p) => p.common_name === name)

  return (
    <div className="animate-fade-in">
      {/* Header */}
      <div className="hero-section mb-8"
           style={{
             background: 'linear-gradient(135deg, rgba(245, 158, 11, 0.06) 0%, rgba(13, 12, 20, 0.85) 40%, rgba(20, 83, 45, 0.04) 100%)',
             border: '1px solid rgba(245, 158, 11, 0.08)'
           }}>
        <div className="hero-orb w-40 h-40 bg-amber-500 top-0 right-0" />

        <div className="relative">
          <div className="flex items-center gap-3 mb-3">
            <div className="w-1 h-10 rounded-full bg-gradient-to-b from-amber-400 to-botanical-500" />
            <div>
              <h1 className="text-xl font-display font-bold text-gradient-gold tracking-wide">
                Doctrine of Signatures
              </h1>
              <p className="text-earth-400 text-sm mt-1">
                How plant form reveals function {'\u2014'} the ancient language of botanical intelligence
              </p>
            </div>
          </div>
          <p className="text-earth-500 text-xs mt-4 font-display italic max-w-2xl leading-relaxed">
            "God hath imprinted upon the Plants, Herbs, and Flowers, as it were in Hieroglyphicks, the very signature of their Vertues." {'\u2014'} The art of reading nature's alphabet, where every leaf, root, and petal communicates its medicine through form, color, and texture.
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-3">
        {/* Entry List */}
        <div className="lg:col-span-1">
          <div className="section-subtitle mb-3">Plant Signatures</div>
          <div className="space-y-2">
            {DOCTRINE_ENTRIES.map((entry) => {
              const plant = findPlantByName(entry.plantName)
              return (
                <button
                  key={entry.plantName}
                  onClick={() => setSelectedEntry(entry)}
                  className={`w-full text-left p-3.5 rounded-xl transition-all duration-200 ease-out-expo ${
                    selectedEntry?.plantName === entry.plantName
                      ? ''
                      : ''
                  }`}
                  style={{
                    background: selectedEntry?.plantName === entry.plantName
                      ? 'rgba(245, 158, 11, 0.08)'
                      : 'rgba(24, 23, 33, 0.5)',
                    border: selectedEntry?.plantName === entry.plantName
                      ? '1px solid rgba(245, 158, 11, 0.15)'
                      : '1px solid rgba(255, 255, 255, 0.04)',
                    boxShadow: selectedEntry?.plantName === entry.plantName
                      ? '0 0 24px rgba(245, 158, 11, 0.06)'
                      : undefined
                  }}
                >
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="text-sm text-earth-200 font-display font-medium">{entry.plantName}</div>
                      <div className="text-xs text-earth-500 mt-0.5 line-clamp-1">{entry.signature}</div>
                    </div>
                    {plant && (
                      <span className={`badge badge-${plant.category} ml-2 flex-shrink-0`}>{plant.category}</span>
                    )}
                  </div>
                </button>
              )
            })}
          </div>
        </div>

        {/* Detail Panel */}
        <div className="lg:col-span-2">
          {selectedEntry ? (
            <div className="animate-fade-in">
              <div className="glass-panel p-6 mb-4"
                   style={{
                     background: 'linear-gradient(135deg, rgba(245, 158, 11, 0.06), rgba(13, 12, 20, 0.85))',
                     border: '1px solid rgba(245, 158, 11, 0.08)'
                   }}>
                <div className="flex items-start justify-between mb-4">
                  <div>
                    <h2 className="text-2xl font-display font-bold text-amber-300">{selectedEntry.plantName}</h2>
                    {findPlantByName(selectedEntry.plantName) && (
                      <p className="text-sm text-earth-500 italic">{findPlantByName(selectedEntry.plantName)!.latin_name}</p>
                    )}
                  </div>
                  {findPlantByName(selectedEntry.plantName) && (
                    <button
                      onClick={() => navigate({ view: 'plant-detail', id: findPlantByName(selectedEntry.plantName)!.id })}
                      className="btn-ghost text-xs"
                    >
                      Full profile {'\u2192'}
                    </button>
                  )}
                </div>

                <div className="space-y-3">
                  <div className="rounded-xl p-4"
                       style={{ background: 'rgba(24, 23, 33, 0.4)', border: '1px solid rgba(255,255,255,0.04)' }}>
                    <div className="section-subtitle mb-1.5">The Signature</div>
                    <p className="text-sm text-earth-300 italic leading-relaxed">{selectedEntry.signature}</p>
                  </div>

                  <div className="rounded-xl p-4"
                       style={{ background: 'rgba(24, 23, 33, 0.4)', border: '1px solid rgba(255,255,255,0.04)' }}>
                    <div className="section-subtitle mb-1.5">Body Correspondence</div>
                    <p className="text-sm text-earth-300">{selectedEntry.bodyPart}</p>
                  </div>

                  <div>
                    <div className="section-subtitle mb-1.5">Reading the Signature</div>
                    <p className="text-sm text-earth-300 leading-relaxed">{selectedEntry.explanation}</p>
                  </div>
                </div>
              </div>

              {/* Key Principles */}
              <div className="card">
                <div className="section-subtitle mb-3">Signature Principles at Work</div>
                <div className="grid grid-cols-2 gap-3">
                  {[
                    { principle: 'Form', desc: 'Shape reveals the organ it heals' },
                    { principle: 'Color', desc: 'Hue indicates energetic alignment' },
                    { principle: 'Texture', desc: 'Feel mirrors tissue it supports' },
                    { principle: 'Habitat', desc: 'Where it grows reveals what it treats' }
                  ].map((p) => (
                    <div key={p.principle} className="rounded-xl p-3"
                         style={{ background: 'rgba(245, 158, 11, 0.04)', border: '1px solid rgba(245, 158, 11, 0.06)' }}>
                      <span className="text-xs text-amber-400/70 font-display font-medium">{p.principle}</span>
                      <p className="text-xs text-earth-400 mt-0.5">{p.desc}</p>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          ) : (
            <div className="card text-center py-16 text-earth-500">
              <div className="text-4xl mb-3 opacity-15 animate-pulse-slow">{'\u2638'}</div>
              <p className="text-lg font-display mb-2">Select a plant signature</p>
              <p className="text-sm">Discover how each plant's form, color, and texture reveal its medicine</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
