import React, { useState } from 'react'
import { Retool } from '@tryretool/custom-component-support'

/* eslint-disable @typescript-eslint/no-explicit-any */

type Metrics = {
  Cost?: number
  Revenue?: number
  Sessions?: number
  Engaged_Sessions?: number
  Transactions?: number
  Attributed_Transactions?: number
  NewUsers?: number
  Impressions?: number
  Link_Clicks?: number
  GA_last_click_revenue?: number
  Attributed_Revenue?: number
  Revenue_minus_embedded_awareness?: number
  embedded_awareness?: number
  CPC?: number
  CTR?: number
  CPM?: number
  CPS?: number
  AROAS?: number
}

interface CampaignNode {
  name: string
  current: Metrics
  prior: Metrics
  children?: CampaignNode[]
}

interface MetricDef {
  key: keyof Metrics
  label: string
  digits: number
  currency?: boolean
  derived?: boolean
  suffix?: string
}

const metricDefs: readonly MetricDef[] = [
  { key: 'Cost', label: 'Spend', digits: 2, currency: true },
  { key: 'Revenue', label: 'Revenue', digits: 2, currency: true },
  {
    key: 'Attributed_Revenue',
    label: 'SP Attributed Rev',
    digits: 2,
    currency: true
  },
  { key: 'Sessions', label: 'Sessions', digits: 0 },
  { key: 'Engaged_Sessions', label: 'Engaged Sessions', digits: 0 },
  { key: 'Transactions', label: 'Transactions', digits: 0 },
  {
    key: 'Attributed_Transactions',
    label: 'Attributed Transactions',
    digits: 0
  },
  { key: 'NewUsers', label: 'New Users', digits: 0 },
  { key: 'Impressions', label: 'Impressions', digits: 0 },
  { key: 'Link_Clicks', label: 'Link Clicks', digits: 0 },
  {
    key: 'GA_last_click_revenue',
    label: 'GA Last Click Rev',
    digits: 2,
    currency: true
  },
  {
    key: 'Revenue_minus_embedded_awareness',
    label: 'Rev minus Awareness',
    digits: 2,
    currency: true
  },
  {
    key: 'embedded_awareness',
    label: 'Embedded Awareness',
    digits: 2,
    currency: true
  },
  { key: 'CPC', label: 'CPC', digits: 2, currency: true, derived: true },
  { key: 'CTR', label: 'CTR', digits: 2, suffix: '%', derived: true },
  { key: 'CPM', label: 'CPM', digits: 2, currency: true, derived: true },
  { key: 'CPS', label: 'CPS', digits: 2, currency: true, derived: true },
  { key: 'AROAS', label: 'Attributed ROAS', digits: 2, derived: true }
] as const

const baseMetricDefs = metricDefs.filter((d) => !d.derived)

interface Classification {
  top: string
  mid: string
}

const classificationMap: Record<string, Classification> = {
  'paid social awareness': {
    top: 'Social',
    mid: 'Social Organic Boosting'
  },
  'paid social - iris': {
    top: 'Social',
    mid: 'Social Mid-Funnel Campaigns'
  },
  'meta - acquisition - mid funnel pm': {
    top: 'Social',
    mid: 'Social Mid-Funnel Campaigns'
  },
  'meta - remarketing - mid funnel pm': {
    top: 'Social',
    mid: 'Social Mid-Funnel Campaigns'
  },
  'youtube - acquisition - mid funnel pm': {
    top: 'Social',
    mid: 'Social Mid-Funnel Campaigns'
  },
  'tiktok - acquisition - mid funnel pm': {
    top: 'Social',
    mid: 'Social Mid-Funnel Campaigns'
  },
  'facebook prospecting - daba': {
    top: 'Social',
    mid: 'Social DABA'
  },
  'pinterest remarketing': {
    top: 'Social',
    mid: 'Social Retargeting'
  },
  'tiktok - remarketing': {
    top: 'Social',
    mid: 'Social Retargeting'
  },
  'tiktok remarketing': {
    top: 'Social',
    mid: 'Social Retargeting'
  },
  'facebook remarketing': {
    top: 'Social',
    mid: 'Social Retargeting'
  },
  'pinterest paid prospecting': {
    top: 'Social',
    mid: 'Social Performance Prospecting'
  },
  'facebook prospecting': {
    top: 'Social',
    mid: 'Social Performance Prospecting'
  },
  'tiktok - remarketing - mid funnel pm': {
    top: 'Non-Paid',
    mid: 'Other'
  },
  'misc/uncategorized': { top: 'Non-Paid', mid: 'Not Set' },
  'not set / not set': { top: 'Non-Paid', mid: 'Not Set' },
  'non-coupon affiliate(s)': {
    top: 'Non-Paid',
    mid: 'Affiliate'
  },
  'coupon affiliate(s)': { top: 'Non-Paid', mid: 'Affiliate' },
  'organic non-brand': {
    top: 'Non-Paid',
    mid: 'Organic Search'
  },
  'organic brand': { top: 'Non-Paid', mid: 'Organic Search' },
  'organic social': { top: 'Non-Paid', mid: 'Organic Social' },
  'pinterest organic': {
    top: 'Non-Paid',
    mid: 'Organic Social'
  },
  referral: { top: 'Non-Paid', mid: 'Referral' },
  email: { top: 'Non-Paid Email/SMS', mid: 'Email/SMS' },
  'attentive - sms/text': {
    top: 'Non-Paid Email/SMS',
    mid: 'Email/SMS'
  },
  direct: { top: 'Non-Paid', mid: 'Direct' },
  'google non-brand shopping': {
    top: 'Shopping',
    mid: 'NBR Shopping'
  },
  'microsoft non-brand shopping': {
    top: 'Shopping',
    mid: 'NBR Shopping'
  },
  'google brand shopping': {
    top: 'Shopping',
    mid: 'BR Shopping'
  },
  'microsoft brand shopping': {
    top: 'Shopping',
    mid: 'BR Shopping'
  },
  'google non-brand text': {
    top: 'Search',
    mid: 'NBR Text'
  },
  'microsoft non-brand text': {
    top: 'Search',
    mid: 'NBR Text'
  },
  'google brand text': {
    top: 'Search',
    mid: 'BR Text'
  },
  'microsoft brand text': {
    top: 'Search',
    mid: 'BR Text'
  },
  'google demand gen': {
    top: 'Display',
    mid: 'Google Display Prospecting'
  },
  'google display ads': {
    top: 'Display',
    mid: 'Google Display Prospecting'
  },
  'youtube prospecting': {
    top: 'Display',
    mid: 'Google Display Prospecting'
  },
  'google display and video retargeting': {
    top: 'Display',
    mid: 'Google Display Remarketing'
  }
}

const defaultTopClassification = (mapping: string): string => {
  if (mapping.includes('shopping')) return 'Shopping'
  if (mapping.includes('search')) return 'Search'
  if (
    mapping.includes('social') ||
    mapping.includes('facebook') ||
    mapping.includes('tiktok')
  )
    return 'Social'
  if (mapping.includes('display') || mapping.includes('daba')) return 'Display'
  if (mapping.includes('email') || mapping.includes('sms'))
    return 'Non-Paid Email/SMS'
  if (
    mapping.includes('organic') ||
    mapping.includes('not set') ||
    mapping.includes('affiliate')
  )
    return 'Non-Paid'
  return 'Other'
}

const classifyInfo = (row: any): Classification => {
  const mapping = (row.New_mapping || '')
    .toLowerCase()
    .replace(/\s+campaigns? items$/, '')
    .trim()
  const found = classificationMap[mapping]
  if (found) return found
  return { top: defaultTopClassification(mapping), mid: 'Other' }
}

const classifyTopLevel = (row: any): string => {
  if (row.Top_Level_Group) return row.Top_Level_Group
  return classifyInfo(row).top
}

const classifySecondLevel = (row: any): string => {
  if (row.Sub_Group) return row.Sub_Group
  return classifyInfo(row).mid
}

const classifyMarketingGroup = (row: any): string => {
  const info = classifyInfo(row)
  // Treat anything that isn't explicitly "Non-Paid" as part of Marketing.
  // This ensures Display and uncategorized rows are grouped under Marketing
  // instead of Non-Marketing.
  return info.top === 'Non-Paid' ? 'Non-Marketing' : 'Marketing'
}

export const CampaignTree = () => {
  const [data] = Retool.useStateObject({
    name: 'data',
    label: 'Campaign Data',
    inspector: 'text',
    description: 'Nested campaign hierarchy'
  })

  const [priorData] = Retool.useStateObject({
    name: 'priorData',
    label: 'Prior Data',
    inspector: 'text',
    description: 'Prior date range data'
  })

  const [layout] = Retool.useStateArray({
    name: 'layout',
    label: 'Nesting Layout',
    inspector: 'text',
    description:
      'JSON array of field names that defines the nesting order. Use "topClassification" for computed top level.',
    initialValue: [
      'topClassification',
      'secondClassification',
      'New_mapping',
      'Campaign_Nm'
    ]
  })

  const [expandedKeys, setExpandedKeys] = useState<Record<string, boolean>>({})
  const [marketingView, setMarketingView] = useState(false)

  const toggleRow = (key: string) => {
    setExpandedKeys((prev) => ({
      ...prev,
      [key]: !prev[key]
    }))
  }

  const columnToRow = (cols: Record<string, any>): any[] => {
    if (!cols || typeof cols !== 'object') return []
    const keys = Object.keys(cols)
    const length = cols[keys[0]]?.length || 0
    return Array.from({ length }, (_, i) => {
      const row: Record<string, any> = {}
      keys.forEach((k) => (row[k] = cols[k][i]))
      return row
    })
  }

  const rowsCurrent = columnToRow(data)
  const rowsPrior = columnToRow(priorData)
  const grouped: CampaignNode[] = []

  const addMetrics = (target: Metrics, row: any) => {
    baseMetricDefs.forEach((def) => {
      const val = row[def.key]
      target[def.key] =
        (target[def.key] || 0) + (typeof val === 'number' ? val : 0)
    })
  }

  const insertRow = (
    nodes: CampaignNode[],
    row: any,
    depth: number,
    keys: string[],
    isPrior: boolean
  ) => {
    const key = keys[depth]
    const rawValue =
      key === 'marketingClassification'
        ? classifyMarketingGroup(row)
        : key === 'topClassification'
          ? classifyTopLevel(row)
          : key === 'secondClassification'
            ? classifySecondLevel(row)
            : row[key]

    if (!rawValue || rawValue === '(Unnamed)') {
      if (depth < keys.length - 1) {
        // Skip unnamed levels and attach children directly to the parent
        insertRow(nodes, row, depth + 1, keys, isPrior)
      }
      return
    }

    let node = nodes.find((n) => n.name === rawValue)
    if (!node) {
      node = { name: rawValue, current: {}, prior: {}, children: [] }
      nodes.push(node)
    }

    addMetrics(isPrior ? node.prior : node.current, row)

    if (depth < keys.length - 1) {
      insertRow(node.children!, row, depth + 1, keys, isPrior)
    }
  }

  const baseLayoutKeys =
    Array.isArray(layout) && layout.length > 0
      ? (layout as string[])
      : [
          'topClassification',
          'secondClassification',
          'New_mapping',
          'Campaign_Nm'
        ]

  const layoutKeys = marketingView
    ? ['marketingClassification', ...baseLayoutKeys]
    : baseLayoutKeys

  rowsCurrent.forEach((row) => {
    insertRow(grouped, row, 0, layoutKeys, false)
  })
  rowsPrior.forEach((row) => {
    insertRow(grouped, row, 0, layoutKeys, true)
  })

  const computeDerivedMetrics = (m: Metrics) => {
    const cost = m.Cost || 0
    const clicks = m.Link_Clicks || 0
    const impressions = m.Impressions || 0
    const sales =
      m.Attributed_Transactions != null
        ? m.Attributed_Transactions
        : m.Transactions || 0
    const attributedRevenue = m.Attributed_Revenue || 0

    m.CPC = clicks ? cost / clicks : undefined
    m.CTR = impressions ? (clicks / impressions) * 100 : undefined
    m.CPM = impressions ? (cost / impressions) * 1000 : undefined
    m.CPS = sales ? cost / sales : undefined
    m.AROAS = cost ? attributedRevenue / cost : undefined
  }

  const computeDerivedForNodes = (nodes: CampaignNode[]) => {
    nodes.forEach((node) => {
      computeDerivedMetrics(node.current)
      computeDerivedMetrics(node.prior)
      if (node.children && node.children.length > 0) {
        computeDerivedForNodes(node.children)
      }
    })
  }

  computeDerivedForNodes(grouped)

  const totals: { current: Metrics; prior: Metrics } = {
    current: {},
    prior: {}
  }
  grouped.forEach((node) => {
    baseMetricDefs.forEach((def) => {
      totals.current[def.key] =
        (totals.current[def.key] || 0) + (node.current[def.key] || 0)
      totals.prior[def.key] =
        (totals.prior[def.key] || 0) + (node.prior[def.key] || 0)
    })
  })
  computeDerivedMetrics(totals.current)
  computeDerivedMetrics(totals.prior)

  const formatNum = (
    num: number | undefined,
    digits: number,
    currency = false,
    suffix = ''
  ) => {
    const value = num != null ? num : 0
    const formatted = value.toLocaleString(undefined, {
      minimumFractionDigits: digits,
      maximumFractionDigits: digits
    })
    const withCurrency = currency ? `$${formatted}` : formatted
    return withCurrency + suffix
  }

  const pctChange = (curr?: number, prior?: number) => {
    if (prior == null || prior === 0 || curr == null) return ''
    return (((curr - prior) / prior) * 100).toFixed(2) + '%'
  }

  const escapeCsv = (value: string): string => {
    if (value.includes('"') || value.includes(',') || value.includes('\n')) {
      return '"' + value.replace(/"/g, '""') + '"'
    }
    return value
  }

  const buildCsvRows = (
    nodes: CampaignNode[],
    path: string[] = []
  ): string[][] => {
    return nodes.flatMap((node) => {
      const name = [...path, node.name].join(' / ')
      const row: string[] = [name]
      metricDefs.forEach((def) => {
        row.push(
          formatNum(
            node.current[def.key],
            def.digits,
            def.currency,
            def.suffix
          ),
          formatNum(node.prior[def.key], def.digits, def.currency, def.suffix),
          pctChange(node.current[def.key], node.prior[def.key])
        )
      })
      const children =
        node.children && node.children.length > 0
          ? buildCsvRows(node.children, [...path, node.name])
          : []
      return [row, ...children]
    })
  }

  const generateCsv = () => {
    const header = [
      'Name',
      ...metricDefs.flatMap((def) => [
        def.label,
        `${def.label} Prior`,
        '% Change'
      ])
    ]
    const rows: string[][] = [header, ...buildCsvRows(grouped)]

    const totalRow: string[] = ['Grand Total']
    metricDefs.forEach((def) => {
      totalRow.push(
        formatNum(
          totals.current[def.key],
          def.digits,
          def.currency,
          def.suffix
        ),
        formatNum(totals.prior[def.key], def.digits, def.currency, def.suffix),
        pctChange(totals.current[def.key], totals.prior[def.key])
      )
    })
    rows.push(totalRow)

    return rows.map((row) => row.map((c) => escapeCsv(c)).join(',')).join('\n')
  }

  const downloadCsv = () => {
    const csv = generateCsv()
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' })
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.setAttribute('download', 'campaign_data.csv')
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    URL.revokeObjectURL(url)
  }

  let rowCounter = 0

  const renderRows = (
    nodes: CampaignNode[],
    depth = 0,
    parentKey = ''
  ): JSX.Element[] => {
    return nodes.flatMap((node, index) => {
      const key = `${parentKey}-${index}`
      const isExpanded = expandedKeys[key]
      const hasChildren =
        Array.isArray(node.children) && node.children.length > 0

      const rowColor = rowCounter % 2 === 0 ? '#ffffff' : '#f2f2f2'
      rowCounter++

      return [
        <tr
          key={key}
          style={{
            fontWeight: hasChildren ? 'bold' : 'normal',
            background: rowColor
          }}
        >
          <td style={{ padding: '4px 8px', minWidth: '240px' }}>
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                paddingLeft: `${depth * 24}px`
              }}
            >
              {hasChildren && (
                <button
                  onClick={() => toggleRow(key)}
                  style={{ marginRight: '6px' }}
                >
                  {isExpanded ? '▾' : '▸'}
                </button>
              )}
              <span>{node.name}</span>
            </div>
          </td>
          {metricDefs.flatMap((def) => {
            const curr = node.current[def.key]
            const prior = node.prior[def.key]
            return [
              <td key={`${key}-${def.key}`} style={{ padding: '4px 8px' }}>
                {formatNum(curr, def.digits, def.currency, def.suffix)}
              </td>,
              <td key={`${key}-${def.key}-p`} style={{ padding: '4px 8px' }}>
                {formatNum(prior, def.digits, def.currency, def.suffix)}
              </td>,
              <td key={`${key}-${def.key}-c`} style={{ padding: '4px 8px' }}>
                {pctChange(curr, prior)}
              </td>
            ]
          })}
        </tr>,
        ...(isExpanded && hasChildren
          ? renderRows(node.children!, depth + 1, key)
          : [])
      ]
    })
  }

  return (
    <div style={{ fontFamily: 'sans-serif', padding: '12px' }}>
      <div style={{ marginBottom: '12px' }}>
        <label>
          <input
            type="checkbox"
            checked={marketingView}
            onChange={(e) => setMarketingView(e.target.checked)}
          />{' '}
          Marketing vs Non-Marketing
        </label>
        <button onClick={downloadCsv} style={{ marginLeft: '12px' }}>
          Export CSV
        </button>
      </div>
      <div style={{ overflowX: 'auto' }}>
        <table
          style={{
            width: '100%',
            borderCollapse: 'collapse',
            fontSize: '14px'
          }}
        >
          <thead>
            <tr style={{ textAlign: 'left', borderBottom: '2px solid #ccc' }}>
              <th style={{ padding: '4px 8px', minWidth: '240px' }}>Name</th>
              {metricDefs.flatMap((def) => [
                <th key={def.key} style={{ padding: '4px 8px' }}>
                  {def.label}
                </th>,
                <th key={def.key + '-p'} style={{ padding: '4px 8px' }}>
                  {def.label} Prior
                </th>,
                <th key={def.key + '-c'} style={{ padding: '4px 8px' }}>
                  % Change
                </th>
              ])}
            </tr>
          </thead>
          <tbody>{renderRows(grouped)}</tbody>
          <tfoot>
            <tr
              style={{
                fontWeight: 'bold',
                borderTop: '2px solid #ccc',
                background: rowCounter % 2 === 0 ? '#ffffff' : '#f2f2f2'
              }}
            >
              <td style={{ padding: '4px 8px' }}>Grand Total</td>
              {metricDefs.flatMap((def) => {
                const curr = totals.current[def.key]
                const prior = totals.prior[def.key]
                return [
                  <td key={`total-${def.key}`} style={{ padding: '4px 8px' }}>
                    {formatNum(curr, def.digits, def.currency, def.suffix)}
                  </td>,
                  <td key={`total-${def.key}-p`} style={{ padding: '4px 8px' }}>
                    {formatNum(prior, def.digits, def.currency, def.suffix)}
                  </td>,
                  <td key={`total-${def.key}-c`} style={{ padding: '4px 8px' }}>
                    {pctChange(curr, prior)}
                  </td>
                ]
              })}
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  )
}

export default CampaignTree
