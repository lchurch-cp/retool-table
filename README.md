## Custom component libraries template

Use this as a base for new custom component library projects within [Retool](https://www.retool.com).

To learn more about how custom component libraries work, visit our [official documentation](https://docs.retool.com/apps/guides/custom/custom-component-libraries).

### Nesting Layout

This component accepts a **layout** state value which controls how data rows are
nested. Provide a JSON array of field names under the `layout` state to specify
the order of groupings. The special key `"topClassification"` can be used to
group rows using the built‑in classification logic.
