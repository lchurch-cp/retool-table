import React, { useState } from 'react';
import { Retool } from '@tryretool/custom-component-support';

/* eslint-disable @typescript-eslint/no-explicit-any */

type Metrics = {
  Cost?: number;
  Revenue?: number;
  Sessions?: number;
  Transactions?: number;
  NewUsers?: number;
  GA_last_click_revenue?: number;
  Attributed_Revenue?: number;
  Revenue_minus_embedded_awareness?: number;
  embedded_awareness?: number;
};

interface CampaignNode {
  name: string;
  current: Metrics;
  prior: Metrics;
  children?: CampaignNode[];
}

const metricDefs = [
  { key: 'Cost', label: 'Cost', digits: 2 },
  { key: 'Revenue', label: 'Revenue', digits: 2 },
  { key: 'Sessions', label: 'Sessions', digits: 0 },
  { key: 'Transactions', label: 'Transactions', digits: 0 },
  { key: 'NewUsers', label: 'New Users', digits: 0 },
  { key: 'GA_last_click_revenue', label: 'GA Last Click Rev', digits: 2 },
  { key: 'Attributed_Revenue', label: 'Attributed Rev', digits: 2 },
  { key: 'Revenue_minus_embedded_awareness', label: 'Rev minus Awareness', digits: 2 },
  { key: 'embedded_awareness', label: 'Embedded Awareness', digits: 2 }
] as const;

export const CampaignTree = () => {
  const [data] = Retool.useStateObject({
    name: 'data',
    label: 'Campaign Data',
    inspector: 'text',
    description: 'Nested campaign hierarchy'
  });

  const [priorData] = Retool.useStateObject({
    name: 'priorData',
    label: 'Prior Data',
    inspector: 'text',
    description: 'Prior date range data'
  });

  const [layout] = Retool.useStateArray({
    name: 'layout',
    label: 'Nesting Layout',
    inspector: 'text',
    description:
      'JSON array of field names that defines the nesting order. Use "topClassification" for computed top level.',
    initialValue: ['topClassification', 'New_mapping', 'Campaign_Nm']
  });

  const [expandedKeys, setExpandedKeys] = useState<Record<string, boolean>>({});

  const toggleRow = (key: string) => {
    setExpandedKeys(prev => ({
      ...prev,
      [key]: !prev[key]
    }));
  };

  const columnToRow = (cols: Record<string, any>): any[] => {
    if (!cols || typeof cols !== 'object') return [];
    const keys = Object.keys(cols);
    const length = cols[keys[0]]?.length || 0;
    return Array.from({ length }, (_, i) => {
      const row: Record<string, any> = {};
      keys.forEach(k => (row[k] = cols[k][i]));
      return row;
    });
  };

  const classifyTopLevel = (row: any): string => {
    const mapping = (row.New_mapping || '').toLowerCase();
    if (mapping.includes('shopping')) return 'Shopping';
    if (mapping.includes('search')) return 'Search';
    if (mapping.includes('social') || mapping.includes('facebook') || mapping.includes('tiktok')) return 'Social';
    if (mapping.includes('display') || mapping.includes('daba')) return 'Display';
    if (mapping.includes('organic') || mapping.includes('not set') || mapping.includes('affiliate')) return 'Non-Paid';
    return 'Other';
  };

  const rowsCurrent = columnToRow(data);
  const rowsPrior = columnToRow(priorData);
  const grouped: CampaignNode[] = [];

  const addMetrics = (target: Metrics, row: any) => {
    metricDefs.forEach(def => {
      const val = row[def.key];
      target[def.key] = (target[def.key] || 0) + (typeof val === 'number' ? val : 0);
    });
  };

  const insertRow = (
    nodes: CampaignNode[],
    row: any,
    depth: number,
    keys: string[],
    isPrior: boolean
  ) => {
    const key = keys[depth];
    const value = key === 'topClassification' ? classifyTopLevel(row) : row[key] || '(Unnamed)';

    let node = nodes.find(n => n.name === value);
    if (!node) {
      node = { name: value, current: {}, prior: {}, children: [] };
      nodes.push(node);
    }

    addMetrics(isPrior ? node.prior : node.current, row);

    if (depth < keys.length - 1) {
      insertRow(node.children!, row, depth + 1, keys, isPrior);
    }
  };

  const layoutKeys =
    Array.isArray(layout) && layout.length > 0
      ? (layout as string[])
      : ['topClassification', 'New_mapping', 'Campaign_Nm'];

  rowsCurrent.forEach(row => {
    insertRow(grouped, row, 0, layoutKeys, false);
  });
  rowsPrior.forEach(row => {
    insertRow(grouped, row, 0, layoutKeys, true);
  });

  const totals: { current: Metrics; prior: Metrics } = {
    current: {},
    prior: {}
  };
  grouped.forEach(node => {
    metricDefs.forEach(def => {
      totals.current[def.key] =
        (totals.current[def.key] || 0) + (node.current[def.key] || 0);
      totals.prior[def.key] =
        (totals.prior[def.key] || 0) + (node.prior[def.key] || 0);
    });
  });

  const formatNum = (num: number | undefined, digits: number) =>
    num != null ? num.toFixed(digits) : (0).toFixed(digits);

  const pctChange = (curr?: number, prior?: number) => {
    if (prior == null || prior === 0 || curr == null) return '';
    return (((curr - prior) / prior) * 100).toFixed(2) + '%';
  };

  const renderRows = (nodes: CampaignNode[], depth = 0, parentKey = ''): JSX.Element[] => {
    return nodes.flatMap((node, index) => {
      const key = `${parentKey}-${index}`;
      const isExpanded = expandedKeys[key];
      const hasChildren = Array.isArray(node.children) && node.children.length > 0;

      return [
        <tr
          key={key}
          style={{ fontWeight: hasChildren ? 'bold' : 'normal', background: hasChildren ? '#f9f9f9' : 'inherit' }}
        >
          <td style={{ padding: '4px 8px', minWidth: '240px' }}>
            <div style={{ display: 'flex', alignItems: 'center', paddingLeft: `${depth * 24}px` }}>
              {hasChildren && (
                <button onClick={() => toggleRow(key)} style={{ marginRight: '6px' }}>
                  {isExpanded ? '▾' : '▸'}
                </button>
              )}
              <span>{node.name}</span>
            </div>
          </td>
          {metricDefs.flatMap(def => {
            const curr = node.current[def.key];
            const prior = node.prior[def.key];
            return [
              <td key={`${key}-${def.key}`} style={{ padding: '4px 8px' }}>{formatNum(curr, def.digits)}</td>,
              <td key={`${key}-${def.key}-p`} style={{ padding: '4px 8px' }}>{formatNum(prior, def.digits)}</td>,
              <td key={`${key}-${def.key}-c`} style={{ padding: '4px 8px' }}>{pctChange(curr, prior)}</td>
            ];
          })}
        </tr>,
        ...(isExpanded && hasChildren ? renderRows(node.children!, depth + 1, key) : [])
      ];
    });
  };

  return (
    <div style={{ fontFamily: 'sans-serif', padding: '12px' }}>
      <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '14px' }}>
        <thead>
          <tr style={{ textAlign: 'left', borderBottom: '2px solid #ccc' }}>
            <th style={{ padding: '4px 8px', minWidth: '240px' }}>Name</th>
            {metricDefs.flatMap(def => [
              <th key={def.key} style={{ padding: '4px 8px' }}>{def.label}</th>,
              <th key={def.key + '-p'} style={{ padding: '4px 8px' }}>{def.label} Prior</th>,
              <th key={def.key + '-c'} style={{ padding: '4px 8px' }}>% Change</th>
            ])}
          </tr>
        </thead>
        <tbody>{renderRows(grouped)}</tbody>
        <tfoot>
          <tr style={{ fontWeight: 'bold', borderTop: '2px solid #ccc' }}>
            <td style={{ padding: '4px 8px' }}>Grand Total</td>
            {metricDefs.flatMap(def => {
              const curr = totals.current[def.key];
              const prior = totals.prior[def.key];
              return [
                <td key={`total-${def.key}`} style={{ padding: '4px 8px' }}>
                  {formatNum(curr, def.digits)}
                </td>,
                <td key={`total-${def.key}-p`} style={{ padding: '4px 8px' }}>
                  {formatNum(prior, def.digits)}
                </td>,
                <td key={`total-${def.key}-c`} style={{ padding: '4px 8px' }}>
                  {pctChange(curr, prior)}
                </td>
              ];
            })}
          </tr>
        </tfoot>
      </table>
    </div>
  );
};

export default CampaignTree;
