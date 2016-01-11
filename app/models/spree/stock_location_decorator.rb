Spree::StockLocation.class_eval do

  belongs_to :supplier, class_name: 'Spree::Supplier'

  scope :by_supplier, -> (supplier_id) { where(supplier_id: supplier_id) }

  # Wrapper for creating a new stock item respecting the backorderable config and supplier
  def propagate_variant(variant)
    if self.supplier_id.blank? || variant.suppliers.pluck(:id).include?(self.supplier_id)
      self.stock_items.create!(variant: variant, backorderable: self.backorderable_default)
    end
  end

  def available?(variant)
    stock_item(variant).try(:available?)
  end

end
